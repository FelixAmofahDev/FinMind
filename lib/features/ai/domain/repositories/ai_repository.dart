import '../entities/conversation.dart';

abstract class AiRepository {
  Future<({String conversationId, String answer})> askAi({
    required String message,
    String? conversationId,
  });

  Future<List<Conversation>> listConversations();

  Future<Conversation> getConversation(String conversationId);

  Future<void> deleteConversation(String conversationId);

  Future<Conversation> updateConversation({
    required String conversationId,
    String? title,
    String? status,
  });
}
