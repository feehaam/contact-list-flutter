/*
1. So, first of all, As it was first time for me to work with Flutter 
thats why my codes doesn't seem to have good readability. 
So I'm adding this comments across the codes. 

2. I used file system json data storing for saving 
contacts. So that, the data do not get deleted/lost after closing the app
or doesn't depend on internet. 

The whole thing starts from contacts.dart file
Also, as it uses file system, so technically it will not run in chrome/browsers

*/

import 'package:contacts_list/screens/contact_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const ContactListScreen(),
    );
  }
}
