import 'package:firebasemywordpair/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewName extends StatefulWidget {
  const NewName({Key? key}) : super(key: key);

  @override
  _NewName createState() => _NewName();
}

class _NewName extends State<NewName> {
  Stream<QuerySnapshot<Map<String, dynamic>>> get names =>
      FirebaseFirestore.instance
          .collection('names').snapshots(includeMetadataChanges: true);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    var firstName = '';
    var secondName = '';

    return Scaffold(
        appBar: AppBar(
          title: Text('Adicionar Nome'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('names').snapshots(),
            builder: (context, AsyncSnapshot snapshot){
              if (!snapshot.hasData) return const Text('Carregando...');
              return Container(
                  color: Colors.white,
                  child: NewNameForm(context, firstName, secondName));
            }
        )
    );
  }

  NewNameForm(context, firstName, secondName) {
    int id = 0;
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
                          firstName = newValue!;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
                    child: TextFormField(
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
                          secondName = value!;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        FirebaseFirestore.instance.collection('names').add({
                            'favorite': false,
                            'firstName': firstName,
                            'secondName': secondName,
                            'id': snapshot.data.docs.length,
                          });
                        Navigator.pop(context);
                      },
                      child: Text('Adicionar'),
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