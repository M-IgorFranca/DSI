import 'package:firebasemywordpair/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewUpdate extends StatefulWidget {
  var doc;
  var id;
  var firstName;
  var secondName;
  ViewUpdate({Key? key, @required this.doc, @required this.id, @required this.firstName, @required this.secondName})
      : super(key:key);
  _ViewUpdateState createState() => _ViewUpdateState();
}

class _ViewUpdateState extends State<ViewUpdate> {
  Stream<QuerySnapshot<Map<String, dynamic>>> get names =>
      FirebaseFirestore.instance
          .collection('names').snapshots(includeMetadataChanges: true);

  void _save(BuildContext context, id, firstName, secondName) {
    _formKey.currentState!.save();
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    setState(() {
      widget.firstName;
      widget.secondName;
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('names').snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if (!snapshot.hasData) return const Text('Carregando...');
          return Container(
              color: Colors.white,
              child: updateNameForm(context, firstName, secondName, id, snapshot.data.docs[id]));
        }
    )
    );
  }

  updateNameForm(context, firstName, secondName, id, DocumentSnapshot documentSnapshot) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('names').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return const Text('Carregando...');
          {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
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
                          documentSnapshot.reference.update({
                            'firstName' : newValue!,
                          });
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
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
                          documentSnapshot.reference.update({
                            'secondName' : value!,
                          });
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        _save(context, id, firstName, secondName);
                      },
                      child: Text('Salvar'),
                    ),
                  ),
                ],
              ),
            );
          }
        }
    );
  }
}