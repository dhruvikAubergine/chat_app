import 'package:badges/badges.dart';
import 'package:chat_app/features/home/modals/user_profile.dart';
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
  late UserProfile userProfile;
  String convoId(String user, String peer) {
    return '${user}_$peer';
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ChatsProvider>(context, listen: false).getConversations();
    setUserDetails();
  }

  Future<void> setUserDetails() async {
    // userProfile = await Provider.of<UserProvider>(context, listen: false)
    //     .fetchCurrentUser(FirebaseAuth.instance.currentUser!.uid);

    if (!mounted) return;
    userProfile = AppService.instance.currentUser ??
        await Provider.of<UserProvider>(context, listen: false)
            .fetchCurrentUser(FirebaseAuth.instance.currentUser!.uid);
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
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return const ProfilePage();
              //     },
              //   ),
              // );
              // await FirebaseAuth.instance.signOut();
              // await AppService.instance.terminate();
              await Navigator.pushNamed(
                context,
                ProfilePage.routeName,
              );
            },
          )
          // DropdownButton(
          //   icon: const Icon(Icons.more_vert),
          //   items: const [
          //     DropdownMenuItem(
          //       value: 'profile',
          //       child: Text('Profile'),
          //     ),
          //     DropdownMenuItem(
          //       value: 'logout',
          //       child: Text('Logout'),
          //     )
          //   ],
          //   onChanged: (value) async {
          //     if (value == 'logout') {
          //       await context.read<ChatsProvider>().disposeStream();
          //       if (!mounted) return;
          //       await context.read<UserProvider>().disposeStream();
          //       await FirebaseAuth.instance.signOut();
          //       if (!mounted) return;
          //       await Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const AuthenticationPage(),
          //         ),
          //       );
          //     }
          //     if (!mounted && value == 'profile') {
          //       if (!mounted) return;
          //       await Navigator.pushNamed(context, ProfilePage.routeName);
          //     }
          //   },
          // ),
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
              // final duration =
              // DateTime.now().difference(
              //   DateTime.fromMillisecondsSinceEpoch(
              //     int.parse(item.lastMessage?.timestamp ?? ''),
              //   ),
              // );
              // if (1 > duration.inMinutes) {
              //   timeBefore = 'Now';
              // } else if (24 > duration.inHours) {
              //   timeBefore = 'Today';
              // } else if (48 > duration.inHours) {
              //   timeBefore = 'Yesterday';
              // } else {
              //   // timeBefore = '${duration.inHours} days ago';
              //   final msgDate = DateTime.fromMillisecondsSinceEpoch(
              //     int.parse(item.lastMessage?.timestamp ?? ''),
              //   );
              //   timeBefore = DateFormat('d mmm').format(msgDate);
              // }
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
