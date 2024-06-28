import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tradetrove/screens/favorit.dart';
import 'package:tradetrove/screens/home_screen.dart';
import 'package:tradetrove/screens/profil_screen.dart';
import 'package:tradetrove/screens/Sell_screen.dart';
import 'package:tradetrove/services/registration_service.dart';

class Navbar extends StatefulWidget {
  @override
  NavbarState createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    FavoriteScreen(userId: AuthService.currentUserId ?? ''),
    UploadProductScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(191, 149, 255, 1),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 156, 156, 156),
                blurRadius: 10,
                spreadRadius: 1)
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 5, left: 30, right: 30),
          child: GNav(
            rippleColor: Color.fromARGB(255, 255, 255, 255)!,
            hoverColor: Color.fromARGB(255, 255, 255, 255)!,
            gap: 6,
            activeColor: Color.fromRGBO(0, 0, 0, 1),
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 8),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Color.fromARGB(255, 255, 255, 255)!,
            tabBorderRadius: 10,
            color: const Color.fromARGB(255, 255, 255, 255),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.favorite_border_outlined,
                text: 'Favorite',
              ),
              GButton(
                icon: Icons.sell_outlined,
                text: 'Sell',
              ),
              GButton(
                icon: Icons.people_alt_rounded,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
