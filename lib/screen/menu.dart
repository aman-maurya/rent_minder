import 'package:flutter/material.dart';
import '../utils/app_style.dart';
import 'widgets/icon_button.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.appBgColor,
      appBar: AppBar(title: Text('Menu', style: Styles.appBarHeading,),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Styles.appBgColor ,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 20),
            child: Text('Mange Tenant', style: Styles.menuHeading,),
          ),
          const SizedBox(
            height: 10,
          ),
          GridView(
            physics:  const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 18, right: 20),
            shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10
              ),
              children: <Widget>[
                IconWidget(
                    name: 'Tenant',
                    icon: 'assets/icons/renter.png',
                    bgColor: const Color(0xFF007bff),
                    iconColor: Colors.white,
                    screenName: '/amenities',
                ),
                IconWidget(
                    name: 'Roommate',
                    icon: 'assets/icons/roommate.png',
                    bgColor: const Color(0xFF34c759),
                    iconColor: Colors.white,
                    screenName: '/amenities',
                ),
              ],
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 20),
            child: Text('Mange Property',
              style: Styles.menuHeading,),
          ),
          const SizedBox(
            height: 10,
          ),
          GridView(
            physics:  const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 18, right: 20),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10
            ),
            children: <Widget>[
              IconWidget(
                name: 'Amenities',
                icon: 'assets/icons/amenities.png',
                bgColor: Colors.orange,
                iconColor: Colors.white,
                screenName: '/amenities',
              ),
              IconWidget(
                  name: 'Building',
                  icon: 'assets/icons/building.png',
                  bgColor: Colors.pink,
                  iconColor: Colors.white,
                  screenName: '/building',
              ),
              IconWidget(
                  name: 'Rooms',
                  icon: 'assets/icons/room.png',
                  bgColor: Colors.teal,
                  iconColor: Colors.white,
                  screenName: '/amenities',
              ),
            ],
          )
        ],
      )
    );
  }
}
