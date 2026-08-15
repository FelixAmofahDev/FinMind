import '../../domain/entities/conversation.dart';
import 'message_model.dart';

class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.title,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.messages = const [],
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final messagesList = json['messages'] as List<dynamic>? ?? const <dynamic>[];
    return ConversationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled',
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      messages: messagesList
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'messages': messages.map((m) => (m as MessageModel).toJson()).toList(),
      };
}
