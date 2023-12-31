import "package:flutter/material.dart";
import "package:lims_app/utils/color_provider.dart";
import "package:lims_app/utils/text_utility.dart";

class RedirectButton extends StatelessWidget {
  const RedirectButton(
      {super.key,
      required this.buttonText,
      required this.routeName,
      required this.onClick});

  final String routeName;
  final String buttonText;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            fixedSize: const Size(150, 42),
            shape: const ContinuousRectangleBorder(),
            backgroundColor: ColorProvider.greyColor),
        child: Text(buttonText,
            style: TextUtility.getStyle(18, color: Colors.white)),
        onPressed: () {
          onClick.call();
          // Navigator.pushNamed(context, routeName);
        });
  }
}
