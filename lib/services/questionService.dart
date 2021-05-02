import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brain_teaser/main.dart';
import 'package:firebase_core/firebase_core.dart';

class QuestionService{

  Future<QuerySnapshot> getBeginnerData() async{
    return await FirebaseFirestore.instance.collection('beginnerQuestions').get();
  }

  Future<QuerySnapshot> getIntermediateData() async{
    return await FirebaseFirestore.instance.collection('intermediateQuestions').get();
  }
}