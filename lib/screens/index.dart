import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  static const routeName = '/';
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nigerian Senators"),
        centerTitle: true,
      ),
    );
  }
}
