import 'package:chat_app/features/home/pages/chat_room.dart';
import 'package:chat_app/features/home/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provides a list of user with whom you can chat.
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});
  static const routeName = '/user-list-page';

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Select user'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final users = userProvider.usersList
            ..removeWhere(
              (element) => element.id == FirebaseAuth.instance.currentUser!.uid,
            );
          return ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.profilePictureUrl ?? '',
                  ),
                ),
                title: Text(
                  user.fullName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ChatRoom(
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
    );
  }
}
