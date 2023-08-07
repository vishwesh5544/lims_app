import "package:flutter/material.dart";

class SearchHeader extends StatefulWidget {
  const SearchHeader({required this.headerTitle, required this.placeholder, super.key});

  final String placeholder;
  final String headerTitle;

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent.shade400,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.headerTitle,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
            SizedBox.fromSize(
              size: const Size(150, 50),
              child: TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    filled: true,
                    labelText: widget.placeholder,
                    prefixIcon: const Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Colors.grey))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
