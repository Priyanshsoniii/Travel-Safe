// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gang/child/bottom_screens/add_contacts.dart';
import 'package:gang/child/bottom_screens/chat_page.dart';
import 'package:gang/child/bottom_screens/child_home_page.dart';
import 'package:gang/child/bottom_screens/review_page.dart';
import 'package:gang/components/fab_bar_bottom.dart';
import 'package:gang/profile_mode/settings.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    const HomeScreen(),
    const AddContactsPage(),
    const CheckUserStatusBeforeChat(),
    ReviewPage(),
    // CheckUserStatusBeforeChatOnProfile(),
    const SettingsPage()
    // ReviewPage(),
  ];
  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: DefaultTabController(
          initialIndex: currentIndex,
          length: pages.length,
          child: Scaffold(
              body: pages[currentIndex],
              bottomNavigationBar: FABBottomAppBar(
                onTabSelected: onTapped,
                items: [
                  FABBottomAppBarItem(iconData: Icons.home, text: "home"),
                  FABBottomAppBarItem(
                      iconData: Icons.contacts, text: "contacts"),
                  FABBottomAppBarItem(iconData: Icons.chat, text: "chat"),
                  FABBottomAppBarItem(
                      iconData: Icons.rate_review, text: "Ratings"),
                  FABBottomAppBarItem(
                      iconData: Icons.settings, text: "Settings"),
                ],
              )),
        ));
  }
}
