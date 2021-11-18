import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessagingState();
}

class MessagingState extends State<Messaging> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Messaging Firebase"),
        ),
        body: Expanded(
          child: Column(
            children: [
              Container(
                alignment: AlignmentDirectional.topCenter,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Press to receive message"),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.bottomCenter,
                child: const Text("test"),
              )
            ],
          ),
        ),
      );
}
