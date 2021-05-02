import 'package:flutter/material.dart';
import 'package:brain_teaser/constants.dart';
import 'package:brain_teaser/views/menu.dart';

class Result extends StatelessWidget {
  final int finalScore;
  Result({ this.finalScore });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Your High Score', style: questionStyle,),
            Text(this.finalScore.toString(), style: questionStyle,),
            Text('WELL PLAYED', style: questionStyle,),
            SizedBox(height: 50.0,),
            Row(
              children: [
                button('Main Menu', 0xFFfc3503, (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu()));
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
