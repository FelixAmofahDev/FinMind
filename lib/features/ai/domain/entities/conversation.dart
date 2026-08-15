import 'message.dart';

class Conversation {
  const Conversation({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const <Message>[],
  });

  final String id;
  final String title;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Message> messages;
}
