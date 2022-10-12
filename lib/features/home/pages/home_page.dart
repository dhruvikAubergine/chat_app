import 'package:badges/badges.dart';
import 'package:chat_app/features/home/modals/user_profile.dart';
import 'package:chat_app/features/home/pages/chat_room.dart';
import 'package:chat_app/features/home/pages/profile_page.dart';
import 'package:chat_app/features/home/pages/user_list_page.dart';
import 'package:chat_app/features/home/providers/chats_provider.dart';
import 'package:chat_app/features/home/providers/user_provider.dart';
import 'package:chat_app/services/app_service.dart';
import 'package:chat_app/utils/helperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provides the main home page of the application[list of chats].
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUserId = AppService.instance.userId;
  late UserProfile userProfile;
  String convoId(String user, String peer) {
    return '${user}_$peer';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ChatsProvider>(context, listen: false).getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                ProfilePage.routeName,
              );
            },
          )
        ],
      ),
      body: Consumer<ChatsProvider>(
        builder: (context, value, child) {
          final conversations = value.conversations;

          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 170,
                    width: 170,
                    child: Image.asset(
                      'assets/images/no_conversation.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No Conversation',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You didn't made any conversation yet.\nPlease select user.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, UserListPage.routeName),
                    child: Text(
                      'Chat People',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                late String peerId;
                var isNewMessageArrived = false;

                final item = conversations[index];
                if (item.lastMessage!.idTo == currentUserId &&
                    !item.lastMessage!.read!) {
                  isNewMessageArrived = true;
                }
                for (final id in item.users!) {
                  if (id != AppService.instance.userId) {
                    peerId = id;
                    break;
                  }
                }
                final user = Provider.of<UserProvider>(context, listen: false)
                    .getUserById(peerId);
                return ListTile(
                  leading: isNewMessageArrived
                      ? Badge(
                          badgeColor: Theme.of(context).primaryColor,
                          position: BadgePosition.bottomEnd(bottom: 0, end: 0),
                          child: CircleAvatar(
                            backgroundImage: user.profilePictureUrl != null
                                ? NetworkImage(user.profilePictureUrl!)
                                : null,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: user.profilePictureUrl != null
                              ? NetworkImage(user.profilePictureUrl!)
                              : null,
                        ),
                  title: Text(
                    user.fullName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${item.lastMessage?.content}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        HelperFunctions.getTime(
                          item.lastMessage?.timestamp ?? '',
                        ),
                      ),
                      Text(
                        HelperFunctions.getMsgTime(
                          item.lastMessage?.timestamp ?? '',
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatRoom(
                            convoId: item.id ?? '',
                            peerUser: user,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Chat People',
        onPressed: () => Navigator.pushNamed(context, UserListPage.routeName),
        child: const Icon(Icons.chat_rounded),
      ),
    );
  }
}
