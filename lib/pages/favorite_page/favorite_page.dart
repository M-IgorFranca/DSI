import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'favorite_list.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nomes Favoritos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 1,
      ),
      body: FavoriteList(),
    );
  }
}
