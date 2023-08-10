import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lims_app/utils/color_provider.dart';

import '../utils/strings/add_patient_strings.dart';
import '../utils/text_utility.dart';
import '../utils/utils.dart';

class CommonEditText extends StatelessWidget {
  Function onChange;
  Function? onSubmit;
  TextEditingController controller;
  String hintText;
  String title;
  CommonEditText({required this.onChange, required this.title, this.onSubmit, required this.controller, required this.hintText,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextUtility.getStyle(13)),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        style: TextUtility.getStyle(14, color: ColorProvider.darkGreyColor),
        onChanged: (value) {
          onChange.call(value);
        },
        decoration: InputDecoration(
            hintStyle: TextUtility.getStyle(14, color: ColorProvider.darkGreyColor),
            constraints: const BoxConstraints(maxWidth: 250, minWidth: 180, minHeight: 35, maxHeight: 50),
            border: getOutLineBorder(),
            focusedErrorBorder: getOutLineBorder(),
            errorBorder: getOutLineBorder(),
            disabledBorder: getOutLineBorder(),
            enabledBorder: getOutLineBorder(),
            focusedBorder: getOutLineBorder(),
            hintText: hintText),
      )
    ]);
  }

  // getBorder(){
  //   return OutlineInputBorder(borderSide: BorderSide(color: ColorProvider.greyColor, width: 0.2),);
  // }
}
