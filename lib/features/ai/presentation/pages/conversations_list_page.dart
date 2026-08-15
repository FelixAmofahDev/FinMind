import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/colors.dart';
import '../../../ai/presentation/providers/ai_provider.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/dialogs/confirm_dialog.dart';
import 'chat_page.dart';

class ConversationsListPage extends ConsumerStatefulWidget {
  const ConversationsListPage({super.key});

  @override
  ConsumerState<ConversationsListPage> createState() =>
      _ConversationsListPageState();
}

class _ConversationsListPageState extends ConsumerState<ConversationsListPage> {
  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    if (mounted) {
      ref.invalidate(listConversationsProvider);
    }
  }

  Future<bool?> _confirmDelete(String title) {
    return ConfirmDialog.show(
      context,
      title: 'Delete Conversation',
      message: 'Are you sure you want to delete "$title"? This action cannot be undone.',
    );
  }

  Future<void> _performDelete(String conversationId) async {
    try {
      await ref
          .read(deleteConversationControllerProvider.notifier)
          .delete(conversationId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conversation deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  Future<bool> _onConfirmDismiss(
    BuildContext dialogContext,
    String conversationId,
    String title,
  ) async {
    final confirmed = await _confirmDelete(title);
    if (confirmed == true && mounted) {
      await _performDelete(conversationId);
    }
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context) {
    final conversationsState = ref.watch(listConversationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Assistant', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadConversations,
        child: conversationsState.when(
          loading: () => const Center(child: LoadingIndicator(message: 'Loading conversations...')),
          error: (error, _) => Center(
            child: EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Could not load conversations',
              message: error.toString(),
              action: TextButton.icon(
                onPressed: _loadConversations,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ),
          ),
          data: (conversations) {
            if (conversations.isEmpty) {
              return Center(
                child: EmptyStateWidget(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'No conversations yet',
                  message: 'Start a new conversation with the AI assistant to get help with your business.',
                  action: PrimaryButton(
                    label: 'New Chat',
                    expanded: true,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ChatPage()),
                      );
                    },
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final preview = conversation.messages.isNotEmpty
                    ? conversation.messages.last.content
                    : 'No messages yet';
                final date = DateFormat('MMM d, yyyy').format(conversation.updatedAt);

                return Dismissible(
                  key: Key(conversation.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _onConfirmDismiss(context, conversation.id, conversation.title),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatPage(conversationId: conversation.id),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  conversation.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  preview,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.mute,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.mute,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.mute),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ChatPage()),
          );
        },
        backgroundColor: AppColors.blue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
