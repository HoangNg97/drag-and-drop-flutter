import 'package:dragandropdemo/drag_and_drop.dart';
import 'package:dragandropdemo/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Demo()));
}

class Demo extends StatelessWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Expanded(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DragAndDrop()),
                );
              },
              child: const Text("Open drag and drop"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Messaging(),
                  ),
                );
              },
              child: const Text("Open firebase messaging"),
            ),
          ],
        ),
      ),
    );
  }
}
