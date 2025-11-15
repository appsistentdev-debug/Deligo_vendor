import 'package:flutter/material.dart';

import 'package:delivoo_store/JsonFiles/Chat/message.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final Message message;

  MessageBubble(this.isMe, this.message);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isMe
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // This is crucial for content wrapping
                children: [
                  Text(
                    message.body ?? "",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          color:
                              isMe ? Colors.white : theme.secondaryHeaderColor,
                        ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message.timeDiff ?? "",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 11,
                          color:
                              isMe ? Colors.white : theme.secondaryHeaderColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
