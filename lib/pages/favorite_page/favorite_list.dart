import 'package:firebasemywordpair/data/constants.dart';
import 'package:flutter/material.dart';
import 'favorite_line.dart';

class FavoriteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList>{
  @override
  Widget build(BuildContext context) {
    return _listFavoritos(context);
  }

  Widget _listFavoritos(context) {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemExtent: 80.0,
        itemCount: Constants.names.length,
        itemBuilder: (context, index) => FavoriteLine(
          id: Constants.names[index].id,
          favorite: Constants.names[index].favorite,
          firstName: Constants.names[index].firstName,
          secondName: Constants.names[index].secondName,
        )
    );
  }
}