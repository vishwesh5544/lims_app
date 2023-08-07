import "package:flutter/material.dart";

class LimsBackButton extends StatelessWidget {
  const LimsBackButton({required this.routeName, super.key});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, routeName), child: const Icon(Icons.arrow_back));
  }
}
