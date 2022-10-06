import 'package:chat_app/features/authentication/pages/Authentication_page.dart';
import 'package:chat_app/features/home/modals/user_profile.dart';
import 'package:chat_app/features/home/providers/chats_provider.dart';
import 'package:chat_app/features/home/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userProfile});
  static const routeName = '/profile-page';
  final UserProfile userProfile;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10) + const EdgeInsets.only(top: 80),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10) +
                            const EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              leading: const Text('Name:'),
                              title: Text(
                                widget.userProfile.fullName ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            ListTile(
                              leading: const Text('Email:'),
                              title: Text(
                                widget.userProfile.email ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            ListTile(
                              leading: const Text('Phone:'),
                              title: Text(
                                '${widget.userProfile.phone ?? ''}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 180,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            widget.userProfile.profilePictureUrl != null
                                ? NetworkImage(
                                    widget.userProfile.profilePictureUrl!,
                                  )
                                : null,
                      ),
                    )
                  ],
                ),
                // Card(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: ListTile(
                //     leading: const Icon(Icons.edit),
                //     title: Text(
                //       'Edit Profile',
                //       style: TextStyle(color: Theme.of(context).primaryColor),
                //     ),
                //     onTap: () {},
                //   ),
                // ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.logout_rounded),
                    title: Text(
                      'Log Out',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onTap: () async {
                      await context.read<ChatsProvider>().disposeStream();
                      if (!mounted) return;
                      await context.read<UserProvider>().disposeStream();

                      await FirebaseAuth.instance.signOut();

                      if (!mounted) return;
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthenticationPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
