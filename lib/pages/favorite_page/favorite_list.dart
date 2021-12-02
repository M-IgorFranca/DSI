import 'package:firebasemywordpair/pages/home/line.dart';
import 'package:flutter/material.dart';
import 'favorite_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList>{
  Stream<QuerySnapshot<Map<String, dynamic>>> get names =>
      FirebaseFirestore.instance
          .collection('names').snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext context) {
    return _listFavoritos(context);
  }

  Widget _listFavoritos(context) {
    var _foundUsers = [];
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('names').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return const Text('Carregando...');
          {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favList.length,
              itemBuilder: (context, index) {
                return FavoriteLine(
                  id: favList[index][0],
                  favorite: favList[index][1],
                  firstName: favList[index][2],
                  secondName: favList[index][3],);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(color: Colors.black38,);
              },
            );
          }
        }
    );

  }
}