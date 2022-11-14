import 'package:chat_app/features/authentication/widgets/login_form.dart';
import 'package:chat_app/features/authentication/widgets/login_part.dart';
import 'package:chat_app/features/authentication/widgets/sign_up_form.dart';
import 'package:chat_app/features/authentication/widgets/sign_up_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: isPortrait ? Axis.vertical : Axis.horizontal,
          child: isPortrait
              ? Column(
                  children: [
                    ClipPath(
                      clipper: isLogIn
                          ? OvalBottomBorderClipper()
                          : CustomClipperTop(),
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        height: isLogIn
                            ? MediaQuery.of(context).size.height * 0.65
                            : MediaQuery.of(context).size.height * 0.35,
                        color: Theme.of(context).primaryColor,
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                        child: isLogIn
                            ? const LoginForm()
                            : LoginPart(onTap: changeState),
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment.center,
                      height: isLogIn
                          ? MediaQuery.of(context).size.height * 0.35
                          : MediaQuery.of(context).size.height * 0.65,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      child: isLogIn
                          ? SignUpPart(onTap: changeState)
                          : const SignUpForm(),
                    )
                  ],
                )
              : Row(
                  children: [
                    ClipPath(
                      clipper:
                          isLogIn ? CustomClipperleft() : CustomClipperRight(),
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(right: 50),
                        width: isLogIn
                            ? MediaQuery.of(context).size.width * 0.60
                            : MediaQuery.of(context).size.width * 0.40,
                        height: MediaQuery.of(context).size.height,
                        color: Theme.of(context).primaryColor,
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                        child: isLogIn
                            ? const LoginForm()
                            : LoginPart(onTap: changeState),
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment.center,
                      width: isLogIn
                          ? MediaQuery.of(context).size.width * 0.40
                          : MediaQuery.of(context).size.width * 0.60,
                      height: MediaQuery.of(context).size.height,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      child: isLogIn
                          ? SignUpPart(onTap: changeState)
                          : const SignUpForm(),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

class CustomClipperTop extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final start = Offset(size.width / 2, size.height - 80);
    final end = Offset(size.width, size.height);
    final path = Path()
      ..lineTo(0, size.height)
      ..quadraticBezierTo(start.dx, start.dy, end.dx, end.dy)
      ..lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomClipperleft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final middle = Offset(size.width + 40, size.height / 2);
    final end = Offset(size.width - 80, size.height);
    final path = Path()
      ..lineTo(size.width - 80, 0)
      ..quadraticBezierTo(middle.dx, middle.dy, end.dx, end.dy)
      ..lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomClipperRight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final middle = Offset(size.width - 80, size.height / 2);
    final end = Offset(size.width, size.height);
    final path = Path()
      ..lineTo(size.width, 0)
      ..quadraticBezierTo(middle.dx, middle.dy, end.dx, end.dy)
      ..lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
