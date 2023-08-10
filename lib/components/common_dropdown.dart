import 'package:flutter/material.dart';
import '../utils/color_provider.dart';
import '../utils/icons/icon_store.dart';
import '../utils/text_utility.dart';
import '../utils/utils.dart';

class CommonDropDown extends StatelessWidget {
  Function onSubmit;
  String hintText;
  String title;
  List<String> list;
  CommonDropDown({required this.title, required this.list, required this.hintText, required this.onSubmit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextUtility.getStyle(13)),
        const SizedBox(height: 6),
        DropdownButtonFormField(
          icon: IconStore.downwardArrow,
          decoration: InputDecoration(
            hintStyle: TextUtility.getStyle(14, color: ColorProvider.darkGreyColor),
            constraints: const BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 40, maxHeight: 45),
            border: getOutLineBorder(),
            focusedErrorBorder: getOutLineBorder(),
            errorBorder: getOutLineBorder(),
            disabledBorder: getOutLineBorder(),
            enabledBorder: getOutLineBorder(),
            focusedBorder: getOutLineBorder(),
            hintText: hintText,
          ),
          items: [
            for(String value in list)
              DropdownMenuItem(value: value, child: Text(value, style: TextUtility.getStyle(13))),
          ],
          onChanged: (value) {
            onSubmit.call(value);
          },
        )
      ],
    );
  }
}
