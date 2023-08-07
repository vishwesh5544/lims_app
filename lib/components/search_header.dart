import "package:flutter/material.dart";
import "package:lims_app/utils/text_utility.dart";

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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent.shade400,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.headerTitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ),
            SizedBox.fromSize(
              size: const Size(250, 45),
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
                maxLines: 1,
                minLines: 1,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    focusColor: Colors.white,
                    filled: true,
                    hintText: widget.placeholder,
                    suffixIcon: InkWell(
                      onTap: (){
                        widget.onClickSearch.call();
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
