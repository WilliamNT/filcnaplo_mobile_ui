import 'package:flutter/material.dart';

class PairButton extends StatelessWidget {
  const PairButton({Key? key, required this.onPressed, required this.child}) : super(key: key);

  // This component is based on the LoginButton() in lib/screens/login/login_button.dart

  final void Function()? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
        ),
        child: child,
      ),
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      minWidth: MediaQuery.of(context).size.width - 64.0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.white,
      textColor: Colors.black,
    );
  }
}
