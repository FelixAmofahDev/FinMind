import '../repositories/ai_repository.dart';

class DeleteConversation {
  const DeleteConversation(this._repository);

  final AiRepository _repository;

  Future<void> call(String conversationId) =>
      _repository.deleteConversation(conversationId);
}
