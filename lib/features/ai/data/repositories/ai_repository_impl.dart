import '../../domain/entities/conversation.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ai_remote_datasource.dart';

class AiRepositoryImpl implements AiRepository {
  const AiRepositoryImpl({
    required AiRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final AiRemoteDatasource _remoteDatasource;

  @override
  Future<({String conversationId, String answer})> askAi({
    required String message,
    String? conversationId,
  }) async {
    final response = await _remoteDatasource.askAi(
      message: message,
      conversationId: conversationId,
    );
    return (conversationId: response.conversationId, answer: response.answer);
  }

  @override
  Future<List<Conversation>> listConversations() async {
    final models = await _remoteDatasource.listConversations();
    return models;
  }

  @override
  Future<Conversation> getConversation(String conversationId) async {
    return await _remoteDatasource.getConversation(conversationId);
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    await _remoteDatasource.deleteConversation(conversationId);
  }

  @override
  Future<Conversation> updateConversation({
    required String conversationId,
    String? title,
    String? status,
  }) async {
    return await _remoteDatasource.updateConversation(
      conversationId: conversationId,
      title: title,
      status: status,
    );
  }
}
