import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/usecases/ask_ai.dart';
import '../../domain/usecases/delete_conversation.dart';
import '../../domain/usecases/get_conversation.dart';
import '../../domain/usecases/list_conversations.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../data/datasources/ai_remote_datasource.dart';

final aiRemoteDatasourceProvider = Provider<AiRemoteDatasource>((ref) {
  return AiRemoteDatasource(ref.read(apiClientProvider));
});

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepositoryImpl(remoteDatasource: ref.read(aiRemoteDatasourceProvider));
});

final listConversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final useCase = ListConversations(ref.read(aiRepositoryProvider));
  return useCase();
});

final conversationDetailProvider =
    FutureProvider.family<Conversation, String>((ref, conversationId) async {
  final useCase = GetConversation(ref.read(aiRepositoryProvider));
  return useCase(conversationId);
});

final askAiControllerProvider =
    AsyncNotifierProvider<AskAiController, AskAiResult>(AskAiController.new);

class AskAiResult {
  const AskAiResult({
    required this.conversationId,
    required this.answer,
  });

  final String conversationId;
  final String answer;
}

class AskAiController extends AsyncNotifier<AskAiResult> {
  @override
  Future<AskAiResult> build() async {
    throw UnimplementedError('Use ask() instead of build.');
  }

  Future<AskAiResult> ask({
    required String message,
    String? conversationId,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final useCase = AskAi(ref.read(aiRepositoryProvider));
      final result = await useCase(message: message, conversationId: conversationId);
      return AskAiResult(
        conversationId: result.conversationId,
        answer: result.answer,
      );
    });

    state = result;
    if (result.value != null) {
      return result.value!;
    }
    throw result.error ?? Exception('Unknown error');
  }
}

final deleteConversationControllerProvider =
    AsyncNotifierProvider<DeleteConversationController, void>(
        DeleteConversationController.new);

class DeleteConversationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> delete(String conversationId) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final useCase = DeleteConversation(ref.read(aiRepositoryProvider));
      await useCase(conversationId);
    });

    state = result;
    if (result.error != null) {
      throw result.error!;
    }
  }
}
