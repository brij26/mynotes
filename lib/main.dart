import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;


void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      routes: {
        "/login/" : (context) => LoginView(),
        "/register/" : (context) => RegisterView()
      },
    ),);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

 @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:  Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user!=null){
              if (user.emailVerified){
                return NotesView();
              }else{
                return VerifyEmailView();
              }
            }else{
              return LoginView();
            }
            default:
              return CircularProgressIndicator();
          }
          
        },
      );
  }
}

enum MenuAction{logout}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Main UI"),
      actions: [PopupMenuButton<MenuAction>(onSelected:(value) async {
        switch (value){
          
          case MenuAction.logout:
            final shouldLogout = await showLogOutDialog(context);
            if (shouldLogout){
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil("/login/", (_) => false,);
            }
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<MenuAction>(value: MenuAction.logout, child: Text("Log out"),)
        ];
      },
      )],),
      body: Text("Hello world"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog(context: context, builder: (context) {
    return AlertDialog(title: Text("Sign out"),
    content: Text("Are you sure you want to log out?"),
    actions: [TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text("Cancel"),),
    TextButton(onPressed: () {Navigator.of(context).pop(true);}, child: Text("Log out"),),],);  
  },
  ).then((value) => value ?? false);
}