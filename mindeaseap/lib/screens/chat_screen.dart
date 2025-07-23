import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';
import '../models/message_model.dart';
import '../widgets/message_bubble.dart';
import '../widgets/suggested_responses.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF4A90E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MindEase AI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    return Text(
                      chatProvider.isLoading ? 'Typing...' : 'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  chatProvider.clearChat();
                },
                tooltip: 'Clear Chat',
              );
            },
          ),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.shouldSuggestCounsellor()) {
                return IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () {
                    _showCounsellorSuggestionDialog();
                  },
                  tooltip: 'Connect with Counsellor',
                );
              }
              return const SizedBox.shrink();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'clear':
                  context.read<ChatProvider>().clearChat();
                  break;
                case 'emergency':
                  _showEmergencyContactsDialog();
                  break;
                case 'settings':
                  // Navigate to settings
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear Chat'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'emergency',
                child: Row(
                  children: [
                    Icon(Icons.emergency, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Emergency Contacts'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return MessageBubble(
                      message: message,
                      isConsecutive: index > 0 && 
                          chatProvider.messages[index - 1].isUser == message.isUser,
                    );
                  },
                );
              },
            ),
          ),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.isLoading) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(width: 16),
                      Text(
                        'MindEase is typing...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              final suggestions = chatProvider.getSuggestedResponses();
              if (suggestions.isNotEmpty && chatProvider.messages.isEmpty) {
                return SuggestedResponses(
                  suggestions: suggestions,
                  onSuggestionTap: (suggestion) {
                    _sendMessage(suggestion);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _sendMessage(value.trim());
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return IconButton(
                onPressed: chatProvider.isLoading ? null : () {
                  if (_messageController.text.trim().isNotEmpty) {
                    _sendMessage(_messageController.text.trim());
                  }
                },
                icon: const Icon(Icons.send),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  shape: const CircleBorder(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    final chatProvider = context.read<ChatProvider>();
    chatProvider.sendMessage(message);
    _messageController.clear();
    _focusNode.requestFocus();
    
    // Scroll to bottom after sending message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showCounsellorSuggestionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect with a Counsellor'),
        content: const Text(
          'Based on our conversation, it might be helpful to connect with a licensed mental health professional. Would you like to be matched with a counsellor?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/counsellor-matching');
            },
            child: const Text('Connect Now'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyContactsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Contacts'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'If you\'re in immediate danger or having thoughts of self-harm, please contact:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _EmergencyContactItem(
                title: 'National Suicide Prevention Lifeline',
                number: '988',
                description: '24/7 crisis support',
              ),
              SizedBox(height: 12),
              _EmergencyContactItem(
                title: 'Crisis Text Line',
                number: 'Text HOME to 741741',
                description: '24/7 text-based crisis support',
              ),
              SizedBox(height: 12),
              _EmergencyContactItem(
                title: 'National Alliance on Mental Illness',
                number: '1-800-950-NAMI (6264)',
                description: 'Information and support',
              ),
              SizedBox(height: 12),
              _EmergencyContactItem(
                title: 'Emergency Services',
                number: '911',
                description: 'Immediate emergency assistance',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _EmergencyContactItem extends StatelessWidget {
  final String title;
  final String number;
  final String description;

  const _EmergencyContactItem({
    required this.title,
    required this.number,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          number,
          style: const TextStyle(
            color: Color(0xFF4A90E2),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

