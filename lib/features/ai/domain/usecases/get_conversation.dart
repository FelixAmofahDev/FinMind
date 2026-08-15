import '../entities/conversation.dart';
import '../repositories/ai_repository.dart';

class GetConversation {
  const GetConversation(this._repository);

  final AiRepository _repository;

  Future<Conversation> call(String conversationId) =>
      _repository.getConversation(conversationId);
}
