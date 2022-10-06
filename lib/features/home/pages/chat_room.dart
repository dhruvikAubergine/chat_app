import 'package:chat_app/features/home/modals/message.dart';
import 'package:chat_app/features/home/modals/user_profile.dart';
import 'package:chat_app/features/home/providers/chats_provider.dart';
import 'package:chat_app/services/app_service.dart';
import 'package:chat_app/utils/helperFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({
    super.key,
    this.convoId,
    required this.peerUser,
  });
  static const routeName = '/chat-room-page';
  String? convoId;
  final UserProfile peerUser;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final currentUserId = AppService.instance.userId;
  final _contentController = TextEditingController();

  String getConvoId(String user, String peer) {
    return '${user}_$peer';
  }

  void onSendMessage(String content) {
    final message = content.trim();
    if (message != '') {
      _contentController.clear();
      Provider.of<ChatsProvider>(context, listen: false).sendMessage(
        widget.convoId!,
        currentUserId,
        widget.peerUser.id ?? '',
        content,
        DateTime.now().millisecondsSinceEpoch.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.convoId ??= getConvoId(currentUserId, widget.peerUser.id!);
    // Provider.of<ChatsProvider>(context, listen: false)
    //     .getChats(widget.convoId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.peerUser.profilePictureUrl ?? ''),
            ),
            const SizedBox(width: 10),
            Text(widget.peerUser.fullName ?? ''),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(widget.convoId)
              .collection(widget.convoId!)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data != null) {
              final messages = snapshot.data!.docs.map((document) {
                final data = document.data()
                  ..putIfAbsent('id', () => document.id);
                return Message.fromJson(data);
              }).toList();
              // final messages = chatsProvider.chats;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        var isSender = false;
                        if (message.idFrom == currentUserId) {
                          isSender = true;
                        }
                        if (!message.read! && message.idTo == currentUserId) {
                          Provider.of<ChatsProvider>(context, listen: false)
                              .updateMessageRead(
                            widget.convoId!,
                            message.id!,
                          );
                        }
                        final msgTime = DateTime.now()
                            .difference(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(message.timestamp ?? ''),
                              ),
                            )
                            .inMinutes;
                        return ChatBubble(
                          backGroundColor: isSender
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primaryContainer,
                          margin: const EdgeInsets.only(top: 10),
                          alignment: isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          clipper: ChatBubbleClipper3(
                            type: isSender
                                ? BubbleType.sendBubble
                                : BubbleType.receiverBubble,
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.content ?? '',
                                  textAlign: TextAlign.left,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (isSender)
                                      Icon(
                                        Icons.done_all,
                                        size: 15,
                                        color: message.read!
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    const SizedBox(width: 5),
                                    Text(
                                      msgTime > 1
                                          ? '${HelperFunctions.getMsgTime(message.timestamp ?? '')}·${HelperFunctions.getTime(
                                              message.timestamp ?? '',
                                            )}'
                                          : HelperFunctions.getMsgTime(
                                              message.timestamp ?? '',
                                            ),
                                      style: const TextStyle(fontSize: 10),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                          maxLines: null,
                          controller: _contentController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Enter message here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => onSendMessage(_contentController.text),
                        icon: Icon(
                          Icons.send_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  )
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// class Temp {
//   Temp({required this.msg, required this.isSender});

//   final String msg;
//   final bool isSender;
// }
