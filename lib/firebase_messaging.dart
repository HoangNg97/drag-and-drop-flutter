import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessagingState();
}

class MessagingState extends State<Messaging> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String message = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Messaging Firebase"),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildButton("Subscribe topic"),
                          buildButton("Unsubscribe Topic"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: AlignmentDirectional.center,
                  child: const Text("test"),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildButton(String text) => TextButton(
        onPressed: () {},
        child: Text(text),
      );
}
