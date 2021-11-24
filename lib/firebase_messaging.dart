import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragandropdemo/device.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

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
  String token = '';
  String senderToken ='';

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    messaging
        .getToken()
        .then((value) => token = value!);
    createNotification();
    FirebaseMessaging.onMessage.listen((event) {
      setState(() {
        message = event.notification?.title;
      });
      print('sendertoken $senderToken');
      print(token);
      if(senderToken == token) {
        return;
      } else{
        AndroidNotification? notification = event.notification?.android;
        if (notification != null) {
          flutterLocalNotificationsPlugin.show(
              1,
              event.notification?.title,
              event.notification?.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                ),
              ));
        }
      }
      senderToken = '';
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
                              sendNotification(
                                  'this is test message', sendmessage);
                              messaging
                                  .getToken()
                                  .then((value) => {if (value != null) senderToken = value});
                            },
                            child: const Text('Send notification'),
                          ),
                          TextField(
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              sendmessage = value;
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
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.max,
);

var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void createNotification() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(android: initializationSettingsAndroid));
}

Future<void> sendNotification(subject, title) async {
  const postUrl = 'https://fcm.googleapis.com/fcm/send';

  String toParams = "/topics/" + Messaging.topic;

  final data = {
    "notification": {"body": subject, "title": title},
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "sound": 'default',
      "isScheduled": "true",
      "scheduledTime": "2021-11-24 17:34:00",
      "screen": Messaging.topic,
    },
    "to": toParams
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization':
        'key=AAAAWpH6mCk:APA91bFvdgFkq2NgKWGuoVzea4D02u9B5kYparOq1b7DlVWe-TkIq4RXBXXuMqDHGGZT_j5n4x_ntzgKarHWxtC-CWSfPRKa9M21Uzl5eBZCSfE1Yoplrf_x59TKHKfqc5M89g49XO-E'
  };

  final response = await http.post(Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
    print("true 200");
  } else {
    print(response.statusCode);
  }
}
