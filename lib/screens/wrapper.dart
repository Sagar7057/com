import 'package:communityapp/screens/posts/add.dart';
import 'package:communityapp/screens/posts/reply.dart';
import 'package:communityapp/screens/profile/edit.dart';
import 'package:communityapp/screens/profile/profile.dart';
import 'package:provider/provider.dart';
import '../models/firebase_user.dart';
import 'package:flutter/material.dart';
import 'authenticate/handler.dart';
import 'authenticate/home.dart';

class Wrapper extends StatelessWidget{
  const Wrapper({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    
    final user =  Provider.of<FirebaseUser?>(context);
    
     if(user == null)
     {
       return const Handler();
     }else
     {
       return MaterialApp(
        initialRoute: '/',
        routes: {
        '/': (context) => const Home(), 
        '/add': (context) => const Add(),
        '/profile': (context) => const Profile(),
        '/edit':(context) => const Edit(),
        '/replies':(context) => const Replies(),
        });
     }

  }
} 