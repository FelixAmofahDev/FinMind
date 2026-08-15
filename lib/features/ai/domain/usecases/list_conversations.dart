import 'package:finmind/features/ai/domain/entities/conversation.dart';

import '../repositories/ai_repository.dart';

class ListConversations {
  const ListConversations(this._repository);

  final AiRepository _repository;

  Future<List<Conversation>> call() => _repository.listConversations();
}
