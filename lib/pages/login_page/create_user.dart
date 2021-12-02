import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final auth = FirebaseAuth.instance;
  late User user;
  String senha = '';
  String validaSenha = '';
  String email = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
            Center(child: Text(widget.title, textAlign: TextAlign.center))),
        body: Container(
          margin: const EdgeInsets.all(20.0),
          child: Form(
            child: _formUI(),
          ),
        ));
  }

  Widget _formUI() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          // alignment: WrapAlignment.center,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              validator: (input) => input == '' ? 'Digite um email' : null,
              onSaved: (value) => email = value!,
            ),
            TextFormField(
              obscureText: true,
              //deixa a senha secreta
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Senha',
              ),
              validator: (input) => input == '' ? 'Digite uma senha' : null,
              onSaved: (value) => senha = value!,
            ),
            TextFormField(
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Digite novamente a senha',
              ),
              validator: (input) =>
              input == '' ? 'Repita novamente a senha' : null,
              onSaved: (value) => validaSenha = value!,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                if (senha != validaSenha) {
                  showDialog(
                    context: context,
                    builder: (_) => _senhaInvalida(),
                    barrierDismissible: false,
                  );
                } else if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  SingUp();
                }
              },
              label: const Text("Cadastrar"),
            ),
          ],
        ));
  }

  Widget _senhaInvalida() {
    return AlertDialog(
      title: const Text('Erro'),
      content: const Text('As senhas inseridas precisam ser iguais'),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Ok'),
        )
      ],
    );
  }
  Future<void> SingUp() async{
    final formState = _formKey.currentState;
    if(formState!.validate()){
      formState.save();
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: senha);
        user = auth.currentUser!;
        user.sendEmailVerification();
        Navigator.of(context).pop();
      }catch(e){
        print(e);
      }
    }
  }
}