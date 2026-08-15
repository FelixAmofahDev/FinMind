import '../entities/conversation.dart';
import '../repositories/ai_repository.dart';

class UpdateConversation {
  const UpdateConversation(this._repository);

  final AiRepository _repository;

  Future<Conversation> call({
    required String conversationId,
    String? title,
    String? status,
  }) =>
      _repository.updateConversation(
        conversationId: conversationId,
        title: title,
        status: status,
      );
}
