import 'dart:async';

import 'package:brain_teaser/services/questionService.dart';
import 'package:brain_teaser/views/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brain_teaser/constants.dart';
import 'package:brain_teaser/views/result.dart';

class Intermediate extends StatefulWidget {
  @override
  _IntermediateState createState() => _IntermediateState();
}

class _IntermediateState extends State<Intermediate> {
  int finalScore = 0;
  int listPointer = 0;
  int time;
  Timer _timer;
  int questionListLength = 0;
  var something;
  var completeQuestionObjList = [];
  var questionObjList = [];
  bool isLoading = true;
  bool isWrongAns = false;
  QuestionService questionService = QuestionService();

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
    time = 9;
    var oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (time == 0) {
        if (listPointer < questionListLength - 1) {
          setState(() {
            time = 9;
            listPointer++;
          });
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Result(
                        finalScore: finalScore,
                      )));
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
    questionService.getIntermediateData().then((QuerySnapshot snapshot) {
      something = snapshot;
      setQuestionList(something);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                builder: (context) =>
                    Result(
                      finalScore: finalScore,
                    )));
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Color(0xFFebe3e1),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 30.0,
              ),
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                          if (listPointer < questionListLength - 1) {
                            listPointer++;
                          }
                          else{Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) =>
                                  Result(finalScore: finalScore,)));}
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.all(10.0),
                        color: Colors.red,
                        child: Text('Continue', style: heading,),)
                  ),
                  SizedBox(height: 20.0,),
                ],
              )
                  : Text(''),
              // SizedBox(
              //   height: 50.0,
              // ),
              Row(
                children: [
                  button(questionObjList[listPointer]['op1'], 0xFFfc2b1c,
                          () {
                        traverser(questionObjList[listPointer]['op1']);
                        time = 8;
                      }),
                ],
              ),
              Row(
                children: [
                  button(questionObjList[listPointer]['op2'], 0xFF12cc2b,
                          () {
                        traverser(questionObjList[listPointer]['op2']);
                        time = 8;
                      }),
                ],
              ),
              Row(
                children: [
                  button(questionObjList[listPointer]['op3'], 0xFF0966e0,
                          () {
                        traverser(questionObjList[listPointer]['op3']);
                        time = 8;
                      }),
                ],
              ),
              Row(
                children: [
                  button(questionObjList[listPointer]['op4'], 0xFFfc05d7,
                          () {
                        traverser(questionObjList[listPointer]['op4']);
                        time = 8;
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
