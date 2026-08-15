class AskAiRequest {
  AskAiRequest({
    required this.message,
    this.conversationId,
  });

  factory AskAiRequest.fromJson(Map<String, dynamic> json) {
    return AskAiRequest(
      message: json['message'] as String? ?? '',
      conversationId: json['conversationId'] as String?,
    );
  }

  final String message;
  final String? conversationId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message,
        if (conversationId != null) 'conversationId': conversationId,
      };
}

class AskAiResponse {
  AskAiResponse({
    required this.conversationId,
    required this.answer,
  });

  factory AskAiResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return AskAiResponse(
      conversationId: data['conversationId'] as String? ?? '',
      answer: data['answer'] as String? ?? '',
    );
  }

  final String conversationId;
  final String answer;
}
