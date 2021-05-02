import 'package:brain_teaser/views/beginner.dart';
import 'package:brain_teaser/views/menu.dart';
import 'package:flutter/material.dart';
import 'package:brain_teaser/constants.dart';

class StartMenu extends StatelessWidget {
  final Widget quizSelector;
  StartMenu({this.quizSelector});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.0,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(5.0),
                child: Text(
                  'Try to answer as many as you can. Let\'s Go',
                  style: questionStyle,
                ),
              ),
            ),
            actionButton('Start', 0xFF0fa320, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => quizSelector));
            }),
            actionButton('Back', 0xFFff4314, () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Menu()));
            }),
          ],
        ),
      ),
    );
  }
}
