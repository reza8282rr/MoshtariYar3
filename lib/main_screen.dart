import 'package:flutter/material.dart';
import 'feed_screen.dart';
import 'add_post_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String username;
  MainScreen({required this.username});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      FeedScreen(),
      AddPostScreen(username: widget.username),
      ProfileScreen(username: widget.username),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'خانه'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'پست جدید'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'پروفایل'),
        ],
      ),
    );
  }
}
