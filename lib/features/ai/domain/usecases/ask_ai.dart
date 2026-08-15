import '../repositories/ai_repository.dart';

class AskAi {
  const AskAi(this._repository);

  final AiRepository _repository;

  Future<({String conversationId, String answer})> call({
    required String message,
    String? conversationId,
  }) {
    return _repository.askAi(message: message, conversationId: conversationId);
  }
}
