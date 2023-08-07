import "package:flutter/material.dart";

class RedirectButton extends StatelessWidget {
  const RedirectButton({super.key, required this.buttonText, required this.routeName});

  final String routeName;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            fixedSize: const Size(120, 60),
            shape: const ContinuousRectangleBorder(), 
            backgroundColor: Colors.blueAccent.shade400),
        child: Text(buttonText),
        onPressed: () => Navigator.pushNamed(context, routeName));
  }
}
