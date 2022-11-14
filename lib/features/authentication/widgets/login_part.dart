import 'package:flutter/material.dart';

class LoginPart extends StatefulWidget {
  const LoginPart({
    super.key,
    required this.onTap,
  });
  final Function onTap;

  @override
  State<LoginPart> createState() => _LoginPartState();
}

class _LoginPartState extends State<LoginPart> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: MediaQuery.of(context).orientation == Orientation.portrait
          ? const NeverScrollableScrollPhysics()
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      shrinkWrap: true,
      children: [
        const Text(
          'Already have an account?',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        MaterialButton(
          height: 50,
          onPressed: () => widget.onTap(),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'Log In',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
