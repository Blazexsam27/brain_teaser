import 'package:brain_teaser/helper/helperfunctions.dart';
import 'package:brain_teaser/views/signIn.dart';
import 'package:brain_teaser/views/signUp.dart';
import 'package:brain_teaser/views/start.dart';
import 'package:flutter/material.dart';
import 'package:brain_teaser/constants.dart';
import 'package:brain_teaser/views/beginner.dart';
import 'package:brain_teaser/views/intermediate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:brain_teaser/services/authService.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  AnimationController controller;
  AuthService _authService = AuthService();

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('BRAINY',
                      speed: Duration(milliseconds: 400), textStyle: heading)
                ],
              ),
            ],
          ),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      _authService.signOut();
                      HelperFunction.saveUserLoggedInSharedPreference(false);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      padding: EdgeInsets.all(10.0),
                      height: 40.0,
                      child: Row(
                        children: [
                          Image(image: AssetImage("assets/images/log-out.png")),
                          Text(
                            'SignOut',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      color: Color(0xFFe3e3e3),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                  child: Center(
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFfab1b6),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    "*IN THESE TWO QUIZ YOU HAVE TO GIVE WRONG ANSWERS INSTEAD OF RIGHT ANSWERS.",
                    style: TextStyle(
                        color: Color(0xFFab000c),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
              )),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                    color: Color(0xFFe3e3e3).withOpacity(controller.value),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  ' Beginner level: Simple questions \n 10s of time to answer.',
                  style: infoText,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                    color: Color(0xFFe3e3e3).withOpacity(controller.value),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  ' Intermediate level: \nModerate questions 8s of time to answer.',
                  style: infoText,
                ),
              ),
              SizedBox(
                height: 70.0,
              ),
              Row(
                children: [
                  button('Beginner', 0xFFff2954, () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StartMenu(
                                  quizSelector: Beginner(),
                                )));
                  })
                ],
              ),
              Row(
                children: [
                  button('Intermediate', 0xFFff2954, () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StartMenu(
                                  quizSelector: Intermediate(),
                                )));
                  }),
                ],
              ),
            ]),
      ),
    );
  }
}
