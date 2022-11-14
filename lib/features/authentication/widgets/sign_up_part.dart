import 'package:flutter/material.dart';

class SignUpPart extends StatefulWidget {
  const SignUpPart({
    super.key,
    required this.onTap,
  });
  final Function onTap;

  @override
  State<SignUpPart> createState() => _SignUpPartState();
}

class _SignUpPartState extends State<SignUpPart> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        physics: MediaQuery.of(context).orientation == Orientation.portrait
            ? const NeverScrollableScrollPhysics()
            : null,
        shrinkWrap: true,
        children: [
          Text(
            'OR',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 15),
          MaterialButton(
            height: 50,
            onPressed: () => widget.onTap(),
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'SIGN UP',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
