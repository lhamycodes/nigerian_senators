import 'package:flutter/material.dart';

import './screens/index.dart';
import './screens/contact.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nigerian Senators',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: "Poppins",
      ),
      routes: {
        '/' : (ctx) => Index(),
        '/contact-details' : (ctx) => ContactDetails(),
      },
    );
  }
}
