import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);
  static const topic = 'du_an';

  @override
  State<StatefulWidget> createState() => MessagingState();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class MessagingState extends State<Messaging> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? message = "";
  String sendmessage = "";

  @override
  void initState() {
    super.initState();
    messaging
        .getToken()
        .then((value) => {if (value != null) print('token is $value')});
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((event) {
      setState(() {
        message = event.notification?.title;
      });
    });
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
                          buildButton("Join project", true),
                          buildButton("Quit project", false),
                          TextButton(
                            onPressed: () {
                              sendFcmMessage('PDCA', sendmessage);
                            },
                            child: const Text('Send notification'),
                          ),
                          TextField(
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              sendmessage = value;
                              print(sendmessage);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(message!),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildButton(String text, bool isJoin) => TextButton(
        onPressed: () {
          if (isJoin) {
            messaging
                .subscribeToTopic(Messaging.topic)
                .whenComplete(
                    () => Fluttertoast.showToast(msg: 'Da join du an'))
                .onError((error, stackTrace) => 'Join Failed');
          } else {
            messaging
                .unsubscribeFromTopic(Messaging.topic)
                .whenComplete(() => Fluttertoast.showToast(msg: 'Da out du an'))
                .onError((error, stackTrace) => 'Out Failed');
          }
        },
        child: Text(text),
      );

  void sendMessage(String message) {
    FirebaseMessaging.instance.sendMessage(
      to: Messaging.topic,
      data: {'PDCA': message},
    );
  }

  Future<bool> sendFcmMessage(String title, String message) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAWpH6mCk:APA91bFvdgFkq2NgKWGuoVzea4D02u9B5kYparOq1b7DlVWe-TkIq4RXBXXuMqDHGGZT_j5n4x_ntzgKarHWxtC-CWSfPRKa9M21Uzl5eBZCSfE1Yoplrf_x59TKHKfqc5M89g49XO-E",
      };
      var request = {
        "notification": {
          "title": title,
          "text": message,
          "sound": "default",
          "color": "#990000",
        },
        "priority": "high",
        "to": "/topics/all",
      };

      var response = await Dio().post(url,
          options: Options(headers: header), data: json.encode(request));
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }
}
