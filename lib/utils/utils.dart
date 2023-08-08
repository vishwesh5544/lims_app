import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lims_app/utils/text_utility.dart';

import 'color_provider.dart';

const String dateFormat = "yyyy-MM-dd";

showToast({String msg = ""}){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0
  );
}

commonBtn({String text = "Next", Color? bgColor, bool isEnable = false, required Function calll}){
  bgColor = bgColor??ColorProvider.blueDarkShade;
 return GestureDetector(
    onTap: (){
      calll.call();
    },
    child: Container(
        height: 45,
        width: 140,
        decoration: BoxDecoration(
            border: Border.all(
                color: ColorProvider.blueDarkShade,
                width: 2
            ),
            color: isEnable ? bgColor : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5))
        ),
        child: Center(child: Text(text, style:
        TextUtility.getBoldStyle(16, color: isEnable? Colors.white: Colors.black),))
    ),
  );
}


commonSearchArea({required String title, String hint = "Next", required TextEditingController textController, required Function onSubmit}){
 return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title),
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: SizedBox.fromSize(
          size: const Size(600, 42),
          child: TextField(
            textAlignVertical: TextAlignVertical.bottom,
            maxLines: 1,
            minLines: 1,
            onChanged: (text){
              onSubmit.call(textController.text.trim());
            },
            controller: textController,
            decoration: InputDecoration(
                fillColor: Colors.white,
                border: InputBorder.none,
                focusColor: Colors.white,
                filled: true,
                hintText: hint,
                suffixIcon: InkWell(
                    onTap: (){
                      onSubmit.call(textController.text.trim());
                    },
                    child: const Icon(Icons.search)),
                enabledBorder: TextUtility.getBorderStyle(),
                disabledBorder: TextUtility.getBorderStyle(),
                errorBorder: TextUtility.getBorderStyle(),
                focusedBorder: TextUtility.getBorderStyle(),
                focusedErrorBorder: TextUtility.getBorderStyle()),
          ),
        ),
      ),
    ],
  );
}


/// date picker
Widget datePicker({required Function onClick, String title = "From Date", required TextEditingController datePickerTextController}) {
  String dateText = datePickerTextController.text;

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
       Text(title),
      // const SizedBox(height: 10),
      TextFormField(
        controller: datePickerTextController,
        decoration: InputDecoration(
            constraints: const BoxConstraints(maxWidth: 200, minWidth: 150, minHeight: 40, maxHeight: 45),
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
            hintText: dateText.isNotEmpty ? dateText : "Select Date"),
        readOnly: true,
        onTap: () {
          onClick.call();
        },
        onChanged: (value) {},
      )
    ],
  );

}