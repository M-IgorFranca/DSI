import 'package:flutter/material.dart';
import 'line.dart';
import 'package:firebasemywordpair/data/constants.dart';

class List extends StatefulWidget {
  const List({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListState();
}

class _ListState extends State<List>{
  @override
  Widget build(BuildContext context) {
    return list(context);
  }

  Widget list(context) {
    setState(() {});
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemExtent: 80.0,
      itemCount: Constants.names.length,
      itemBuilder: (context, index) => Line(
        id: Constants.names[index].id,
        favorite: Constants.names[index].favorite,
        firstName: Constants.names[index].firstName,
        secondName: Constants.names[index].secondName,)
    );
  }
}