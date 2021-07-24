import 'package:flutter/material.dart';

import 'screens/display_qr.dart';
import 'screens/scan_qr.dart';

void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfffca43c),
        appBar: AppBar(
          elevation: 20,
          // yellowish hex : #fca43c
          // pink hex : #da2854
          title: Text(
            'Crypt QR',
            style: TextStyle(
                fontWeight: FontWeight.w300, fontFamily: "BEYNO", fontSize: 30),
          ),
          backgroundColor: Color(0xffda2854),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_selectedIndex == 0 ? 0 : 40),
          ),
          centerTitle: true,
        ),
        body: listOfWidgets(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          iconSize: 30,
          elevation: 20,
          backgroundColor: Color(0xfffca43c),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(color: Color(0xffda2854)),
          unselectedIconTheme: IconThemeData(color: Colors.pink[400]),
          unselectedItemColor: Colors.pink,
          selectedItemColor: Color(0xffda2854),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code_scanner_outlined,
              ),
              backgroundColor: Color(0xfffca43c),
              label: 'Scan QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code_outlined,
              ),
              label: 'Create QR',
              backgroundColor: Color(0xfffca43c),
            ),
          ],
        ),
      ),
    );
  }
}

Widget listOfWidgets(index) {
  List<Widget> l = [
    qrCodeScannerPage(), //have to chage this
    qrCodeDisplayPage(),
  ];
  return l[index];
}
