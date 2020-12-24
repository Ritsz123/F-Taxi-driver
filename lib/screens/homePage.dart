import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  static const id = "homePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
