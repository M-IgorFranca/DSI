import 'package:firebasemywordpair/pages/home/home_page.dart';
import 'package:firebasemywordpair/pages/login_page/create_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String senha = '';
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
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Senha',
              ),
              validator: (input) => input!.length < 5 ? 'Digite uma senha com no mínimo 5 caracteres' : null,
              onSaved: (value) => senha = value!,
              //maxLength: 10, coloca um limite no número de caracteres;
            ),
            FloatingActionButton.extended(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  SingIn();
                }
              },
              label: const Text("Entrar"),

            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const RegisterPage(title: 'Criar conta',)));
              },
              label: const Text("Criar"),

            ),
          ],
        ));
  }
  Future<void> SingIn() async{
    final formState = _formKey.currentState;
    if(formState!.validate()){
      formState.save();
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage(),));
      }catch(e){
        print(e);
      }
    }
  }
}