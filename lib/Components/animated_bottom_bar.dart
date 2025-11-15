import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Function onBarTap;
  final int selectedBarIndex;

  AnimatedBottomBar({
    super.key,
    required this.barItems,
    required this.onBarTap,
    required this.selectedBarIndex,
  });

  @override
  AnimatedBottomBarState createState() => AnimatedBottomBarState();
}

class AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, -5),
              )
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildBarItems(),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    final theme = Theme.of(context);
    List<Widget> _barItems = [];
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = widget.selectedBarIndex == i;
      _barItems.add(InkWell(
        onTap: () => widget.onBarTap(i),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 2.0),
            SvgPicture.asset(
              item.image,
              colorFilter: isSelected
                  ? ColorFilter.mode(theme.primaryColor, BlendMode.srcIn)
                  : ColorFilter.mode(
                      theme.unselectedWidgetColor, BlendMode.srcIn),
              height: 20.0,
              width: 20.0,
            ),
            SizedBox(height: 6.0),
            Text(
              item.text,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? theme.primaryColorDark
                    : theme.unselectedWidgetColor,
              ),
            ),
          ],
        ),
      ));
    }
    return _barItems;
  }
}

class BarItem {
  String text;
  String image;

  BarItem({required this.text, required this.image});
}
