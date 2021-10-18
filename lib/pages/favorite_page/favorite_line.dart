import 'package:flutter/material.dart';
import 'package:firebasemywordpair/data/constants.dart';

class FavoriteLine extends StatefulWidget {
  var id;
  var firstName;
  var secondName;
  var favorite;
  FavoriteLine({Key? key, @required this.id, @required this.firstName, @required this.secondName, @required this.favorite})
      : super(key:key);
  State<StatefulWidget> createState() => _FavoriteLineState();
}

class _FavoriteLineState extends State<FavoriteLine>{
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          if (widget.favorite = false)
            Expanded(
              child: Text(
                widget.firstName + ' ' + widget.secondName,
                style: Theme.of(context).textTheme.headline5,
              ),
            )
          else const Text("...")
        ],
      ),
    );
  }
}