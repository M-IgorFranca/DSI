import 'package:firebasemywordpair/pages/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


const errorTitleStyle = TextStyle(color: Colors.yellow, fontSize: 20.0);
const errorDescStyle = TextStyle(
    color: Colors.yellow, fontStyle: FontStyle.italic, fontSize: 16.0);
const exceptionTitleStyle = TextStyle(color: Colors.yellow, fontSize: 20.0);
const exceptionDescStyle =
TextStyle(color: Colors.red, fontStyle: FontStyle.italic, fontSize: 16.0);
const textTitleStyle = TextStyle(fontSize: 20.0);
const textDescStyle = TextStyle(fontSize: 16.0);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyFirebaseApp());
}

class MyFirebaseApp extends StatefulWidget {
  const MyFirebaseApp({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _MyFirebaseAppState createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildAppError(snapshot.error);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        return _buildLoading();
      },
    );
  }
  Directionality _buildAppError(Object? error) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Wrap(
          children: [
            const Text('Error:', style: errorTitleStyle),
            Text('$error', style: errorDescStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(width: 10),
          Text('Loading...', style: textTitleStyle),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (context) => const LoginPage(title: 'Login',)
      },
    );
  }
}