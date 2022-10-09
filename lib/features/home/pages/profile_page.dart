import 'dart:developer';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:chat_app/features/authentication/pages/Authentication_page.dart';
import 'package:chat_app/features/home/modals/user_profile.dart';
import 'package:chat_app/features/home/providers/chats_provider.dart';
import 'package:chat_app/features/home/providers/user_provider.dart';
import 'package:chat_app/services/app_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// Provides a user profiles details.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const routeName = '/profile-page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isEditProfile = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _storedFile;
  bool _isUpdateLoading = false;
  late UserProfile userProfile;

  Future<void> pickImage() async {
    try {
      final imageFile = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);
      if (imageFile != null) {
        final tempImage = File(imageFile.path);

        setState(() {
          _storedFile = tempImage;
        });
        log(_storedFile?.path ?? 'no file piked');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image is not selected')),
        );
      }
    } on Exception catch (e) {
      log(e.toString(), name: 'Image Picker');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image is not selected')),
      );
    }
  }

  Future<void> _onUpdate() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _formKey.currentState?.save();
    final name = _nameController.text.trim();
    final phone = int.parse(_phoneController.text.trim());
    var profilePictureUrl = userProfile.profilePictureUrl!;

    try {
      setState(() => _isUpdateLoading = true);

      if (_storedFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_image')
            .child('${userProfile.id}.jpg');

        await ref.putFile(_storedFile!);

        profilePictureUrl = await ref.getDownloadURL();
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userProfile.id)
          .update({
        'fullName': name,
        'phone': phone,
        'email': userProfile.email,
        'profilePictureUrl': profilePictureUrl
      });
      final user = userProfile.copyWith(
        phone: phone,
        fullName: name,
        profilePictureUrl: profilePictureUrl,
      );
      if (!mounted) return;
      await AppService.instance.updateCurrentUser(user);
      userProfile = AppService.instance.currentUser!;
      setState(() {});
    } catch (error) {
      log(error.toString());
    }
    setState(() => _isUpdateLoading = false);
  }

  Future<void> _setUserProfile() async {
    userProfile = AppService.instance.currentUser ??
        await Provider.of<UserProvider>(context, listen: false)
            .fetchCurrentUser(FirebaseAuth.instance.currentUser!.uid);
    log(userProfile.toString());
  }

  @override
  void initState() {
    _setUserProfile();
    super.initState();

    _nameController.text = userProfile.fullName ?? '';
    _emailController.text = userProfile.email ?? '';
    _phoneController.text = userProfile.phone.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10) + const EdgeInsets.only(top: 80),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!_isEditProfile) ...[
                                ListTile(
                                  leading: const Text('Name:'),
                                  title: Text(
                                    userProfile.fullName ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  leading: const Text('Email:'),
                                  title: Text(
                                    userProfile.email ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  leading: const Text('Phone:'),
                                  title: Text(
                                    '${userProfile.phone ?? ''}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                              if (_isEditProfile) ...[
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _nameController,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  validator: (value) {
                                    final title = value?.trim() ?? '';
                                    if (title.isEmpty) {
                                      return 'Please enter a Name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  readOnly: true,
                                  controller: _emailController,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  controller: _phoneController,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Phone',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  validator: (value) {
                                    final phone = value?.trim() ?? '';
                                    if (phone.isEmpty) {
                                      return 'Please enter your phone number';
                                    } else if (phone.length != 10) {
                                      return 'Please enter a valid phone number';
                                    }
                                    return null;
                                  },
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_isEditProfile)
                      Positioned(
                        bottom: 250,
                        child: Badge(
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          badgeColor: Colors.transparent,
                          badgeContent: IconButton(
                            onPressed: pickImage,
                            icon: const Icon(Icons.camera_alt_rounded),
                          ),
                          position: const BadgePosition(top: 60, start: 70),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _storedFile == null
                                ? NetworkImage(
                                    userProfile.profilePictureUrl!,
                                  )
                                : FileImage(_storedFile!) as ImageProvider,
                          ),
                        ),
                      )
                    else
                      Positioned(
                        bottom: 180,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            userProfile.profilePictureUrl!,
                          ),
                        ),
                      ),
                  ],
                ),
                if (!_isEditProfile) ...[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.edit),
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onTap: () =>
                          setState(() => _isEditProfile = !_isEditProfile),
                    ),
                  ),
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
                        await AppService.instance.terminate();

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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _isEditProfile
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _onUpdate().whenComplete(
                          () =>
                              setState(() => _isEditProfile = !_isEditProfile),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      child: _isUpdateLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                    )
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
