import 'package:brain_teaser/constants.dart';
import 'package:brain_teaser/helper/helperfunctions.dart';
import 'package:brain_teaser/services/authService.dart';
import 'package:brain_teaser/services/databaseService.dart';
import 'package:brain_teaser/views/menu.dart';
import 'package:brain_teaser/views/signUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignIn> with TickerProviderStateMixin {
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthService _authService = AuthService();
  HelperFunction helperFunction = HelperFunction();
  DatabaseService databaseService = DatabaseService();
  var userSnapshot;
  var temp;
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.forward();
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    super.initState();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();

  }

  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunction.saveUserEmailSharedPreference(
          emailTextEditingController.text.trim());
      databaseService
          .getUserByEmail(emailTextEditingController.text.trim())
          .then((value) {
        userSnapshot = value.docs[0];
        HelperFunction.saveUsernameSharedPreference(userSnapshot['name']);
      });
      setState(() {
        isLoading = true;
      });
    }
    _authService
        .signInUser(emailTextEditingController.text.trim(),
            passwordTextEditingController.text.trim())
        .then((value) {
      if (value != null) {
        HelperFunction.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Menu()));
      } else {
        setState(() {
          isLoading = false;
          emailTextEditingController.text =
              passwordTextEditingController.text = "";
          Fluttertoast.showToast(
              msg: 'No User Found With This Email!',
              textColor: Colors.red,
              toastLength: Toast.LENGTH_SHORT,
              fontSize: 14.0,
              gravity: ToastGravity.BOTTOM);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFf52718),
          title: Center(
            child: Text(
              'BRAINY',
              style: heading,
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 140.0,),
                      SizeTransition(
                        sizeFactor: _animation,
                        child: Image(
                          image: AssetImage('assets/images/brain-teaser.png'),
                        ),
                        axis: Axis.vertical,
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                  controller: emailTextEditingController,
                                  decoration: inputFormDecoration('email'),
                                  validator: (value) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)
                                        ? null
                                        : "incorrect Email";
                                  }),
                              TextFormField(
                                  controller: passwordTextEditingController,
                                  decoration: inputFormDecoration('password'),
                                  obscureText: true,
                                  validator: (value) {
                                    return value.length < 6
                                        ? "password is too weak"
                                        : null;
                                  }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          button('SignIn', 0xFF0ea116, () {
                            signIn();
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          button('Sign Up', 0xFFc4103a, () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          })
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      )
                    ]),
            ),
      ),
    );
  }
}
