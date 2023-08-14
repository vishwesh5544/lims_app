import 'package:flutter/material.dart';
import 'package:lims_app/utils/color_provider.dart';

class SideNav extends StatefulWidget {
  const SideNav({
    super.key,
    this.tabsWidth,
    this.tabsHeight,
    required this.tabs,
    required this.tabBackgroundColor,
    required this.selectedTabBackgroundColor,
    required this.onChange,
  });
  final double? tabsWidth, tabsHeight;
  final List<Tab> tabs;
  final Color tabBackgroundColor, selectedTabBackgroundColor;
  final Function(int) onChange;

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorProvider.blueDarkShade,
      width: widget.tabsWidth,
      child: ListView.builder(
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) {
          Tab tab = widget.tabs[index];

          Alignment alignment = Alignment.center;

          Widget child;
          if (tab.child != null) {
            child = tab.child!;
          } else {
            child = Container();
          }

          Color itemBGColor = widget.tabBackgroundColor;
          if (_selectedIndex == index) {
            itemBGColor = widget.selectedTabBackgroundColor;
          }

          return GestureDetector(
            onTap: () {
              widget.onChange.call(index);
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: itemBGColor,
              ),
              height: widget.tabsHeight,
              alignment: alignment,
              padding: const EdgeInsets.all(5),
              child: Center(child: child),
            ),
          );
        },
      ),
    );
  }
}
