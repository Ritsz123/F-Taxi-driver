import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  static const id = "homePage";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: RaisedButton(
        onPressed: () {
          DatabaseReference dbref =
              FirebaseDatabase.instance.reference().child("Driver App");
          dbref.set("isConnected");
        },
        child: "Hello".text.make(),
      ),
    );
  }
}
