import 'package:firebasemywordpair/data/constants.dart';
import 'package:firebasemywordpair/pages/home/home_page.dart';
import 'package:flutter/material.dart';


class ViewUpdate extends StatefulWidget {
  var id;
  var firstName;
  var secondName;
  ViewUpdate({Key? key, @required this.id, @required this.firstName, @required this.secondName})
      : super(key:key);
  _ViewUpdateState createState() => _ViewUpdateState();
}

class _ViewUpdateState extends State<ViewUpdate> {

  void _save(BuildContext context, id, firstName, secondName) {
    _formKey.currentState!.save();
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    setState(() {
      Constants.names[id];
    });
  }
  int? id = 0;
  String? firstName = '';
  String? secondName = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    Map arguments = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;
    var id = arguments['index'];
    var firstName = arguments['firstName'];
    var secondName = arguments['secondName'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit item'),
      ),
      body: Container(
          color: Colors.white,
          child: updateNameForm(context, firstName, secondName, id)),
    );
  }

  updateNameForm(context, firstName, secondName, id) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            child: TextFormField(
              initialValue: firstName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Primeira'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite um valor válido';
                }
                return null;
              },
              onSaved: (newValue) {
                setState(() {
                  Constants.names[id].firstName = newValue!;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            child: TextFormField(
              initialValue: secondName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Segunda'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite um nome válido';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  Constants.names[id].secondName = value!;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            child: ElevatedButton(
              onPressed: () => _save(context, id, firstName, secondName),
              child: Text('Salvar'),
            ),
          ),
        ],
      ),
    );
  }
}
