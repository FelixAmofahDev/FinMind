import 'package:finmind/shared/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../ai/domain/entities/message.dart';
import '../../../ai/presentation/providers/ai_provider.dart';
import '../../../ai/presentation/widgets/chat_bubble.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, this.conversationId});

  final String? conversationId;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isTyping = false;
  String? _currentConversationId;

  @override
  void initState() {
    super.initState();
    _currentConversationId = widget.conversationId;
    if (widget.conversationId != null) {
      _loadConversation(widget.conversationId!);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation(String conversationId) async {
    setState(() => _isTyping = true);
    try {
      final conversation = await ref
          .read(conversationDetailProvider(conversationId).future);
      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(conversation.messages);
          _currentConversationId = conversation.id;
        });
        _scrollToBottom();
      }
    } on Exception {
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load conversation')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTyping = false);
      }
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final conversationId = _currentConversationId;
    setState(() {
      _messages.add(Message(
        id: 'msg_user_${DateTime.now().millisecondsSinceEpoch}',
        role: 'user',
        content: message,
        createdAt: DateTime.now(),
      ));
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      final result = await ref
          .read(askAiControllerProvider.notifier)
          .ask(message: message, conversationId: conversationId);

      if (mounted) {
        setState(() {
          _currentConversationId = result.conversationId;
          _messages.add(Message(
            id: 'msg_ai_${DateTime.now().millisecondsSinceEpoch}',
            role: 'assistant',
            content: result.answer,
            createdAt: DateTime.now(),
          ));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _isTyping = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get response: $e')),
        );
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startNewChat() {
    setState(() {
      _messages.clear();
      _currentConversationId = null;
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: widget.conversationId == null,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AI Assistant',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
              if (_currentConversationId != null)
                Text('Conversation active',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
            ],
          ),
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _startNewChat,
              icon: const Icon(Icons.add_rounded),
              tooltip: 'New Chat',
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _isTyping && _messages.isEmpty
                  ? Center(
                      child: LoadingIndicator(message: 'Loading conversation...'),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        }
                        final message = _messages[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ChatBubble(
                            role: message.role,
                            content: message.content,
                            timestamp: message.createdAt,
                          ),
                        );
                      },
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _messageController,
                      hintText: 'Ask me anything about your business...',
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.newline,
                      onFieldSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_rounded, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
