import 'package:firebasemywordpair/pages/update_name/view_update.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Line extends StatefulWidget {
  var doc;
  var id;
  var firstName;
  var secondName;
  var favorite;
  Line({Key? key, @required this.doc, @required this.id, @required this.firstName, @required this.secondName, @required this.favorite})
      : super(key:key);
  @override
  State<StatefulWidget> createState() => _LineState();
}

class _LineState extends State<Line>{
  @override
  Widget build(BuildContext context) {
    var obj = widget.id;
    var doc = widget.doc;
    return dismiss(context, obj, doc, doc);
  }

    Widget dismiss(context, obj, doc, DocumentSnapshot documentSnapshot){
      return Dismissible(
        key: UniqueKey(),
        child: buildRow(context, obj, doc),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (DismissDirection direction) {
          setState(() {
          });
        },
        confirmDismiss: (DismissDirection endToStart) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirmar"),
                content: const Text("Tem certeza que deseja deletar esse item?"),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        documentSnapshot.reference.delete();
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Deletar")),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("Cancelar"),
                  ),
                ],
              );
            },
          );
        },
      );
    }

  Widget buildRow(context, obj, DocumentSnapshot documentSnapshot) {
    return ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.firstName + ' ' + widget.secondName,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(
                  widget.favorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.favorite ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    if (widget.favorite) {
                      documentSnapshot.reference.update({
                        'favorite' : false,
                      });
                    } else {
                      documentSnapshot.reference.update({
                        'favorite' : true,
                      });
                    }
                  });
                },
              ),
            ),
          ],
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ViewUpdate(),
            settings: RouteSettings(arguments: {'doc':widget.doc, 'index': widget.id, 'firstName': widget.firstName, 'secondName': widget.secondName}))
        )
    );
  }
}