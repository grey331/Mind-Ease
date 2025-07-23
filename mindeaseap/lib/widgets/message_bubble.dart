
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isConsecutive;

  const MessageBubble({
    super.key,
    required this.message,
    this.isConsecutive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: isConsecutive ? 4 : 16,
        left: message.isUser ? 48 : 0,
        right: message.isUser ? 0 : 48,
      ),
      child: Column(
        crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isConsecutive) ...[
            Row(
              mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!message.isUser) ...[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A90E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  message.isUser ? 'You' : 'MindEase AI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
                if (message.isUser) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isUser ? const Color(0xFF4A90E2) : Colors.grey[100],
              borderRadius: BorderRadius.circular(16).copyWith(
                topLeft: message.isUser ? const Radius.circular(16) : const Radius.circular(4),
                topRight: message.isUser ? const Radius.circular(4) : const Radius.circular(16),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

