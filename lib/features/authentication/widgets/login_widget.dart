import 'dart:developer';

import 'package:chat_app/features/home/pages/home_page.dart';
import 'package:chat_app/features/home/providers/user_provider.dart';
import 'package:chat_app/services/app_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';

/// Provides the login page with text field and options to login into the app.
class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key, required this.onTap});
  static const routeName = '/auth-page';
  final Function onTap;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final _auth = auth.FirebaseAuth.instance;

  Future<void> _logIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _formKey.currentState?.save();
    final password = _passwordController.text;
    final email = _emailController.text.trim();

    try {
      setState(() => _isLoading = true);
      // ignore: unused_local_variable
      auth.UserCredential authCredential;
      authCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      final user = await Provider.of<UserProvider>(context, listen: false)
          .fetchCurrentUser(authCredential.user!.uid);
      await AppService.instance.updateCurrentUser(user);

      _isLoading = false;

      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    } on PlatformException catch (error) {
      var message = 'An error occured, please check your credentials';

      if (error.message != null) {
        message = error.message!;
      }
      _isLoading = false;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      log('$error');
      final errorMessage =
          error.toString().substring(error.toString().indexOf(']') + 2);
      _isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.all(20) + const EdgeInsets.only(top: 130),
              children: [
                Text(
                  'Chat App',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'email',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    final title = value?.trim() ?? '';
                    if (title.isEmpty) {
                      return 'Please enter a email';
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
                    labelText: 'password',
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
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                MaterialButton(
                  height: 50,
                  onPressed: _logIn,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(
              height: 200,
            ),
            InkWell(
              onTap: () => widget.onTap(),
              child: ClipPath(
                clipper: WaveClipperTwo(reverse: true),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20) +
                        const EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'OR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                          ),
                        ),
                        MaterialButton(
                          height: 50,
                          onPressed: () => widget.onTap(),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
