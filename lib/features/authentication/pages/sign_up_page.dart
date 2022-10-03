import 'dart:developer';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:chat_app/features/authentication/pages/Authentication_page.dart';
import 'package:chat_app/features/home/modals/user_profile.dart';
import 'package:chat_app/features/home/pages/home_page.dart';
import 'package:chat_app/services/app_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const routeName = '/signin-page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final _auth = auth.FirebaseAuth.instance;

  static const String kEmailRegexPattern =
      r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';

  File? _storedFile;

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

  Future<void> _signUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _formKey.currentState?.save();
    final password = _passwordController.text;
    final email = _emailController.text.trim();
    final fullName = _fullNameController.text.trim();
    // final phone = _phoneController.text.trim();
    final phone = int.parse(_phoneController.text.trim());

    if (_storedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select profile image'),
        ),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);
      auth.UserCredential authCredential;
      authCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_image')
          .child('${authCredential.user!.uid}.jpg');

      await ref.putFile(_storedFile!);

      final profilePictureUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authCredential.user!.uid)
          .set({
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'profilePictureUrl': profilePictureUrl
      });
      final user = UserProfile(
        id: authCredential.user!.uid,
        email: email,
        fullName: fullName,
        phone: phone,
        profilePictureUrl: profilePictureUrl,
      );
      await AppService.instance.updateCurrentUser(user);
      setState(() => _isLoading = false);

      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    } on PlatformException catch (error) {
      var message = 'An error occured, please check your credentials';

      if (error.message != null) {
        message = error.message!;
      }
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (error) {
      log('$error');
      final errorMessage =
          error.toString().substring(error.toString().indexOf(']') + 2);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(15) + const EdgeInsets.only(top: 130),
            children: [
              Badge(
                elevation: 0,
                padding: EdgeInsets.zero,
                badgeColor: Colors.transparent,
                badgeContent: IconButton(
                  onPressed: pickImage,
                  icon: const Icon(Icons.camera_alt_rounded),
                ),
                position: const BadgePosition(top: 45, start: 190),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _storedFile != null
                      ? FileImage(
                          _storedFile!,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  final name = value?.trim() ?? '';
                  if (name.isEmpty) return 'Please enter your name';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
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
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty ||
                      !RegExp(kEmailRegexPattern).hasMatch(email)) {
                    return 'Please enter a valid email id';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.password],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  final pass = value ?? '';
                  if (pass.isEmpty) {
                    return 'Please enter a password';
                  } else if (pass.length <= 8) {
                    return 'Password must be greater than 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              MaterialButton(
                height: 50,
                onPressed: _signUp,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AuthenticationPage.routeName);
                    },
                    child: const Text('Log In'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
