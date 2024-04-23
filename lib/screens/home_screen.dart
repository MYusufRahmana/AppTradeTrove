import 'package:flutter/material.dart';
import 'package:tradetrove/screens/profil_screen.dart';
import 'package:tradetrove/services/registration_service.dart'; // Import halaman profil

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final RegistrationService getUser = RegistrationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi'),
      ),
      body: Center(
        child: _buildPage(_currentIndex),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.purple.shade500,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Handle navigation to profile screen when profile tab is tapped
            if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.white),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.white),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sell, color: Colors.white),
              label: 'Jual',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.white),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.white),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Container(
          child: Center(
            child: Text('Home Page'),
          ),
        );
      case 1:
        return Container(
          child: Center(
            child: Text('Search Page'),
          ),
        );
      case 2:
        return Container(
          child: Center(
            child: Text('Favorite Page'),
          ),
        );
      case 3:
        return Container(
          child: Center(
            child: Text('Profile Page'),
          ),
        );
      default:
        return Container();
    }
  }
}
