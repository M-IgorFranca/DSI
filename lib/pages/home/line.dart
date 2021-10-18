import 'package:firebasemywordpair/pages/update_name/view_update.dart';
import 'package:flutter/material.dart';

class Line extends StatefulWidget {
  var id;
  var firstName;
  var secondName;
  var favorite;
  Line({Key? key, @required this.id, @required this.firstName, @required this.secondName, @required this.favorite})
    : super(key:key);
  @override
  State<StatefulWidget> createState() => _LineState();
}

class _LineState extends State<Line>{
  @override
  Widget build(BuildContext context) {
    var obj = widget.id;
    return Dismissible(
      key: UniqueKey(),
      child: buildRow(context, obj),
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
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Deletar")),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildRow(context, obj) {
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
                      widget.favorite = false;
                      print(widget.favorite);
                    } else {
                      widget.favorite = true;
                      print(widget.favorite);
                    }
                  });
                },
              ),
            ),
          ],
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ViewUpdate(),
            settings: RouteSettings(arguments: {'index': widget.id, 'firstName': widget.firstName, 'secondName': widget.secondName}))
        )
    );
  }
}