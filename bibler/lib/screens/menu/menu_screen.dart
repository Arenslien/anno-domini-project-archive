import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _page = 0; // The current page displayed
  PageController pageController = PageController(); // The controller for the page view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        // The page view
        children: const <Widget>[],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        // The bottom navigation bar
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            // The first item :
            icon: Icon(
              Icons.favorite, // Please change the icon here
              color: (_page == 0) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            // The second item :
            icon: Icon(
              Icons.favorite, // Please change the icon here
              color: (_page == 1) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            // The third item :
            icon: Icon(
              Icons.favorite, // Please change the icon here
              color: (_page == 2) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            // The fourth item :
            icon: Icon(
              Icons.favorite, // Please change the icon here
              color: (_page == 3) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _page,
        onTap: onTap,
      ),
    );
  }

  // Method to change the page displayed
  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  // Method to change the page displayed
  void onTap(int page) {
    pageController.jumpToPage(page);
  }
}
