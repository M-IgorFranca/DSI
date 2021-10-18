import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebasemywordpair/pages/favorite_page/favorite_page.dart';
import 'list.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyApp', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 1,
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  const FavoritePage()),
            );
          }),
        ],
      ),
      body: List(),
    );
  }
}