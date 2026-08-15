class Message {
  const Message({
    required this.id,
    required this.role,
    required this.content,
    this.createdAt,
  });

  final String id;
  final String role;
  final String content;
  final DateTime? createdAt;
}
