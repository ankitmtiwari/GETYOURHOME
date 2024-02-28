import 'package:flutter/material.dart';
import 'package:get_your_home/Screens/BottomNavigationBarScreens/edit_property_screen.dart';
import 'package:get_your_home/Screens/BottomNavigationBarScreens/home_screen.dart';
import 'package:get_your_home/Screens/BottomNavigationBarScreens/profile_screen.dart';
import 'package:get_your_home/Screens/BottomNavigationBarScreens/search_screen.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MainHomePage> {
  List pages = const [
    HomePage(),
    SearchPage(),
    FavoritesPage(),
    ProfilePage(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.06,
        child: BottomNavigationBar(
          onTap: onTap,
          type: BottomNavigationBarType.shifting,
          currentIndex: currentIndex,
          selectedItemColor: Colors.blue,
          iconSize: MediaQuery.of(context).size.height * 0.035,
          unselectedItemColor: Colors.blue,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 2,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
              label: "Home",
              tooltip: "Home",
            ),
             BottomNavigationBarItem(
              icon: Icon(currentIndex == 1 ? Icons.search_sharp : Icons.search_outlined),
              label: "Search",
              tooltip: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  currentIndex == 2 ? Icons.edit : Icons.edit_outlined),
              label: "Edit",
              tooltip: "Edit",
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(currentIndex == 3 ? Icons.person : Icons.person_outline),
              label: "My",
              tooltip: "Profile",
            )
          ],
        ),
      ),
    );
  }
}
