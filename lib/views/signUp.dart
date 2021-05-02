import 'package:brain_teaser/constants.dart';
import 'package:brain_teaser/helper/helperfunctions.dart';
import 'package:brain_teaser/services/authService.dart';
import 'package:brain_teaser/services/databaseService.dart';
import 'package:brain_teaser/views/menu.dart';
import 'package:brain_teaser/views/signIn.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin{
  TextEditingController userNameTextEditingController =
  new TextEditingController();
  TextEditingController emailTextEditingController =
  new TextEditingController();
  TextEditingController passwordTextEditingController =
  new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthService _authService = AuthService();
  DatabaseService databaseService = DatabaseService();
  Map<String, String> userInfoMap;
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState(){
    _controller = AnimationController(
        duration: Duration(seconds: 2),
        vsync: this
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  signMeUp() {
    if (formKey.currentState.validate()) {
      userInfoMap = {
        "email" : emailTextEditingController.text.trim(),
        "name" : userNameTextEditingController.text.trim()
      };
      HelperFunction.saveUsernameSharedPreference(userNameTextEditingController.text.trim());
      HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text.trim());

      setState(() {
        isLoading = true;
      });
      databaseService.uploadUserInf(userInfoMap);
      _authService
          .signUpUserByEmailAndPassword(emailTextEditingController.text.trim(),
          passwordTextEditingController.text.trim())
          .then((value) {
        if (value != null) {
          HelperFunction.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Menu()));
        } else {
          setState(() {
            isLoading = false;
            userNameTextEditingController.text =
                emailTextEditingController.text =
                passwordTextEditingController.text = "";
            Fluttertoast.showToast(
                msg: "Email Id Already In Use",
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.red,
                fontSize: 14.0,
                gravity: ToastGravity.BOTTOM);
          });
        }
      });
    }
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
                SizedBox(height: 140,),
        Container(
        margin: EdgeInsets.all(5.0),
        child: Form(
          key: formKey,
          child: Column(
              children: [
                SizeTransition(
                      sizeFactor: _animation,
                      child: Image( image: AssetImage('assets/images/brain-teaser.png'),),
                      axis: Axis.vertical,
                  ),

                TextFormField(
                  controller: userNameTextEditingController,
                  decoration: inputFormDecoration('username'),
                  validator: (val) {
                    if (val.isEmpty || val.length < 3) {
                      return "username must be at least 3 characters long";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailTextEditingController,
                  decoration: inputFormDecoration('email'),
                  validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                        .hasMatch(val)
                        ? null
                        : "Wrong email";
                  },
                ),
                TextFormField(
                  controller: passwordTextEditingController,
                  decoration: inputFormDecoration('password'),
                  obscureText: true,
                  validator: (val) {
                    return val.isEmpty || val.length < 6
                        ? "Password is very weak"
                        : null;
                  },
                ),
              ],
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(children: [
        button('SignUp', 0xFFc4103a, () {
          signMeUp();
        }),
        SizedBox(
          height: 20,
        ),
      ]),
      Row( children: [
        button('Already have an account ? SignIn', 0xFF0ea116, (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
        })
      ],),
                SizedBox(height: 10.0,)
      ],
      ),
            ),
    ),);
  }
}
