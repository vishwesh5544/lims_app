import "package:flutter/material.dart";
import "package:lims_app/utils/text_utility.dart";

import "../utils/color_provider.dart";

class SearchHeader extends StatefulWidget {
  SearchHeader(
      {required this.headerTitle, required this.placeholder, required this.onClickSearch, super.key});

  final String placeholder;
  final String headerTitle;
  Function onClickSearch;

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: ColorProvider.blueDarkShade,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.headerTitle,
              style: const TextStyle(
                  color: Colors.white,
                  // fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            SizedBox.fromSize(
              size: const Size(250, 40),
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
                maxLines: 1,
                minLines: 1,
                onChanged: (text){
                  widget.onClickSearch.call(text.trim());
                },
                controller: textController,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    focusColor: Colors.white,
                    filled: true,
                    hintText: widget.placeholder,
                    suffixIcon: InkWell(
                      onTap: (){
                        widget.onClickSearch.call(textController.text.trim().toString());
                      },
                        child: const Icon(Icons.search)),
                    enabledBorder: TextUtility.getBorderStyle(),
                    disabledBorder: TextUtility.getBorderStyle(),
                    errorBorder: TextUtility.getBorderStyle(),
                    focusedBorder: TextUtility.getBorderStyle(),
                    focusedErrorBorder: TextUtility.getBorderStyle()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
