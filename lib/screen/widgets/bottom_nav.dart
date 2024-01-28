import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rent_minder/screen/menu.dart';
import 'package:rent_minder/utils/app_style.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  static const List<Widget> _widgetOptions = <Widget>[
    Menu(),
    Text(
      'Dashboard',
      style: optionStyle,
    ),
    Text(
      'Payment',
      style: optionStyle,
    ),
    Text(
      'Settings',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            )
          ),
          child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GNav(
              tabs:  [
                GButton(
                  icon: Icons.menu_rounded,
                  text: 'Menu',
                  textStyle: Styles.bottomNavBarTabBtn,
                ),
                GButton(
                  icon: Icons.dashboard_rounded,
                  text: 'Dashboard',
                  textStyle: Styles.bottomNavBarTabBtn,
                ),
                GButton(
                  icon: Icons.payment_rounded,
                  text: 'Payment',
                  textStyle: Styles.bottomNavBarTabBtn,
                ),
                GButton(
                  icon: Icons.settings_rounded,
                  text: 'Settings',
                  textStyle: Styles.bottomNavBarTabBtn,
                ),
              ],
              // tabActiveBorder: Border.all(color: const Color(0xFF283593), width: 1),
              backgroundColor: Colors.grey.shade200,
              iconSize: 26,
              color: Colors.grey.shade700,
              activeColor: const Color(0xFF283593),
              // tabBackgroundColor: Colors.grey.shade50,
              // rippleColor: Styles.bottomNavBarTab, // tab button ripple color when pressed
              // hoverColor: Styles.bottomNavBarTab, // tab button hover color
              haptic: true, // haptic feedback
              curve: Curves.easeInOutCirc, // tab animation curves
              duration: const Duration(milliseconds: 900), // tab animation duration
              gap: 4, // the tab button gap between icon and text
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          )),
        ));
  }
}
