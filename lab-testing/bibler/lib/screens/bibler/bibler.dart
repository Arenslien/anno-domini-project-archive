import 'package:flutter/material.dart';
import 'package:bibler/screens/bibler/bible.dart';
import 'package:bibler/screens/bibler/community.dart';
import 'package:bibler/screens/bibler/home.dart';
import 'package:bibler/screens/bibler/group.dart';
import 'package:bibler/screens/bibler/my_info.dart';


class BiblerScreen extends StatefulWidget {
  @override
  _BiblerScreenState createState() => _BiblerScreenState();
}

class _BiblerScreenState extends State<BiblerScreen> {
  int _currentIndex = 2;
  final List<Widget> _body = [
    BibleBody(), CommunityBody(), HomeBody(), GroupBody(), InfoBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _body[_currentIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            // icon: Tab(icon: Image.asset("assets/bible.png"),),
            label: '성경',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.commute),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: '그룹(모임)',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}