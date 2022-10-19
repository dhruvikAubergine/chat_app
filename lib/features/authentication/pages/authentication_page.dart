import 'package:chat_app/features/authentication/widgets/login_widget.dart';
import 'package:chat_app/features/authentication/widgets/sign_up_widget.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});
  static const routeName = '/first-page';

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool isLogIn = true;

  void changeState() {
    setState(() => isLogIn = !isLogIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLogIn ? Theme.of(context).primaryColor : null,
      body: SafeArea(
        child: AnimatedCrossFade(
          firstChild: LoginWidget(onTap: changeState),
          secondChild: SignUpWidget(onTap: changeState),
          duration: const Duration(seconds: 1),
          crossFadeState:
              isLogIn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      ),
    );
  }
}
