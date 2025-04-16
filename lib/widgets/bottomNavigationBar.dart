import 'package:flutter/material.dart';
import '../../core/utils/theme/colors.dart'; // Assurez-vous que ce chemin est correct

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const CustomBottomNavigationBar({
    required this.currentIndex, required this.onTap, required this.items, Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: kBackgroundColor,
          fixedColor: currentIndex == 0 ? Colors.white : kPrimaryColor,
          unselectedItemColor: Colors.white,
          unselectedFontSize: 10,
          iconSize: 18,
          currentIndex: currentIndex,
          onTap: (index) {
            onTap(index);
            setState(() {});
          },
          items: items,
        );
      },
    );
  }
}
