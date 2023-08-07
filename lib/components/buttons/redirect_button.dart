import "package:flutter/material.dart";
import "package:lims_app/utils/text_utility.dart";

class RedirectButton extends StatelessWidget {
   RedirectButton({super.key, required this.buttonText, required this.routeName, required this.onClick});

  final String routeName;
  final String buttonText;
  Function onClick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            fixedSize: const Size(150, 45),
            shape: const ContinuousRectangleBorder(), 
            backgroundColor: Colors.blueAccent.shade400),
        child: Text(buttonText, style: TextUtility.getStyle(18, color: Colors.white)),
        onPressed: () {
          onClick.call();
          // Navigator.pushNamed(context, routeName);
        });
  }
}
