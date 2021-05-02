import 'dart:async';
import 'package:brain_teaser/helper/helperfunctions.dart';
import 'package:brain_teaser/views/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brain_teaser/constants.dart';
import 'package:brain_teaser/views/result.dart';
import 'package:brain_teaser/services/questionService.dart';

class Beginner extends StatefulWidget {
  @override
  _BeginnerState createState() => _BeginnerState();
}

class _BeginnerState extends State<Beginner> {
  int finalScore = 0;
  int listPointer = 0;
  int questionListLength = 0;
  bool isLoading = true;
  bool isWrongAns = false;
  int time;
  Timer _timer;
  var questionData;
  QuestionService questionService = QuestionService();
  List<dynamic> completeQuestionObjList = [];
  List<dynamic> questionObjList = [];

  setQuestionList(object) {
    for (int i = 0; i < object.docs.length; i++) {
      completeQuestionObjList.add(object.docs[i]);
    }
    questionListLength = 7;
    completeQuestionObjList.shuffle();
    questionObjList.addAll(completeQuestionObjList.take(7));
    isLoading = false;
    countDown();

  }
  void countDown() {
    time = 11;
    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      if (time == 0) {
        if (listPointer < questionListLength - 1) {
          setState(() {
            listPointer++;
            time = 11;
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Result(
                finalScore: finalScore,
              ),
            ),
          );
        }
      } else {
        setState(() {
          time--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    questionService.getBeginnerData().then((QuerySnapshot snapshot) {
      questionData = snapshot;
      setQuestionList(questionData);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void traverser(String userSelectedOption) {
    if (userSelectedOption == questionObjList[listPointer]['ans']) {
      setState(() {
        finalScore++;
      });
    } else {
      setState(() {
        isWrongAns = true;
        _timer.cancel();
      });
    }
    if (!isWrongAns) {
      if (listPointer < questionListLength - 1) {
        countDown();
        setState(() {
          listPointer++;
        });
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Result(
                      finalScore: finalScore,
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Hero(
        tag: 'screen',
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Color(0xFFebe3e1),
                child: Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 30.0),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          color: Colors.white70,
                          child: Text(
                            "Q) " + questionObjList[listPointer]['q1'],
                            style: questionStyle,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                              child: Center(
                        child: Text(
                          time.toString(),
                          style: timer,
                        ),
                      ))),
                      isWrongAns
                          ? Column(
                              children: [
                                Text(
                                  "Oops!",
                                  style: questionStyle,
                                ),
                                Text("The right answer is :"),
                                Text(questionObjList[listPointer]['ans']),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isWrongAns = false;
                                        if (listPointer <
                                            questionListLength - 1) {
                                          listPointer++;
                                        } else {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Result(
                                                        finalScore: finalScore,
                                                      )));
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      margin: EdgeInsets.all(10.0),
                                      color: Colors.red,
                                      child: Text(
                                        'Continue',
                                        style: heading,
                                      ),
                                    )),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            )
                          : Text(''),
                      SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        children: [
                          button(questionObjList[listPointer]['op1'],
                              0xFFfc2b1c, () {
                            traverser(
                                questionObjList[listPointer]['op1']);
                            time = 10;
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          button(questionObjList[listPointer]['op2'],
                              0xFF12cc2b, () {
                            traverser(
                                questionObjList[listPointer]['op2']);
                            time = 10;
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          button(questionObjList[listPointer]['op3'],
                              0xFF0966e0, () {
                            traverser(
                                questionObjList[listPointer]['op3']);
                            time = 10;
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          button(questionObjList[listPointer]['op4'],
                              0xFFfc05d7, () {
                            traverser(
                                questionObjList[listPointer]['op4']);
                            time = 10;
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
