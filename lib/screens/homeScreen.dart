import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_driver_app/Colors.dart';
import 'package:uber_driver_app/tabs/earningsTab.dart';
import 'package:uber_driver_app/tabs/homeTab.dart';
import 'package:uber_driver_app/tabs/profileTab.dart';
import 'package:uber_driver_app/tabs/ratingsTab.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  static const id = "homePage";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int _selectedIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      _selectedIndex = index;
      tabController.index = _selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: BouncingScrollPhysics(),
        controller: tabController,
        children: [
          HomeTab(),
          EarningsTab(),
          RatingsTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onItemClicked,
        currentIndex: _selectedIndex,
        unselectedItemColor: MyColors.colorIcon,
        selectedItemColor: MyColors.colorOrange,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: "Earnings"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Ratings"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: "Profile")
        ],
      ),
    );
  }
}
