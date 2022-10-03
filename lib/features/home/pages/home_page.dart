import 'package:badges/badges.dart';
import 'package:chat_app/features/home/pages/chat_room.dart';
import 'package:chat_app/features/home/pages/profile_page.dart';
import 'package:chat_app/features/home/pages/user_list_page.dart';
import 'package:chat_app/features/home/providers/chats_provider.dart';
import 'package:chat_app/features/home/providers/user_provider.dart';
import 'package:chat_app/services/app_service.dart';
import 'package:chat_app/utils/helperFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUserId = AppService.instance.userId;
  String convoId(String user, String peer) {
    return '${user}_$peer';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUsers();

    Provider.of<ChatsProvider>(context, listen: false).getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [
          DropdownButton(
            icon: const Icon(Icons.more_vert),
            items: const [
              DropdownMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              DropdownMenuItem(
                value: 'logout',
                child: Text('Logout'),
              )
            ],
            onChanged: (value) {
              if (value == 'logout') {
                context.read<ChatsProvider>().disposeStream();
                context.read<UserProvider>().disposeStream();
                FirebaseAuth.instance.signOut();
              }
              if (value == 'profile') {
                Navigator.pushNamed(context, ProfilePage.routeName);
              }
            },
          ),
        ],
      ),
      body: Consumer<ChatsProvider>(
        builder: (context, value, child) {
          final conversations = value.conversations;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              String timeBefore;
              late String peerId;
              var isNewMessageArrived = false;

              final item = conversations[index];
              final duration = DateTime.now().difference(
                DateTime.fromMillisecondsSinceEpoch(
                  int.parse(item.lastMessage?.timestamp ?? ''),
                ),
              );
              if (1 > duration.inMinutes) {
                timeBefore = 'Now';
              } else if (24 > duration.inHours) {
                timeBefore = 'Today';
              } else if (48 > duration.inHours) {
                timeBefore = 'Yesterday';
              } else {
                timeBefore = '${duration.inHours} days ago';
              }
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
              final user =
                  Provider.of<UserProvider>(context).getUserById(peerId);
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
                title: Text(user.fullName ?? ''),
                subtitle: Text(
                  '${item.lastMessage?.content}',
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
                    Text(timeBefore)
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, UserListPage.routeName);
        },
        child: const Icon(Icons.chat_rounded),
      ),
    );
  }
}
