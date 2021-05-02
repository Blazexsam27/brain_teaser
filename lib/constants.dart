import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

const heading = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 25.0,
  color: Color(0xFFeeeeee)
);

const timer = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 55.0,
  color: Colors.black
);

const infoText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
    color: Colors.black
);

const subHeader = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  color: Color(0xFFeeeeee)
);

const questionStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: Color(0xFF000000)
);


InputDecoration inputFormDecoration(String text){
  return InputDecoration(
      hintText: text,
      focusColor: Color(0xFF1526e8)
  );
}

Expanded button(String text, int color, [Function navigate]){
  return Expanded(
      child: GestureDetector(
        onTap: navigate,
        child: Container(
          padding: EdgeInsets.all(17.0),
          margin: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              color: Color(color),
              borderRadius: BorderRadius.circular(8.0)
          ),
          child: Center(child: Text(text, style: subHeader,)),
        ),
      )
  );
}

Row actionButton(String text, int color, Function act){
  return  Row(
    children: [
      button(text, color, act),
    ],
  );
}
