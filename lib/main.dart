import 'dart:async';

import 'package:brain_teaser/views/beginner.dart';
import 'package:brain_teaser/views/menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:brain_teaser/views/signIn.dart';
import 'package:brain_teaser/views/signUp.dart';
import 'package:connectivity/connectivity.dart';
import 'package:brain_teaser/helper/helperfunctions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  bool userLoggedInState = false;
  String _connectionStatus = "Unknown";
  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void getUserLoggedInState() async {
    await HelperFunction.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        if (value != null) {
          userLoggedInState = value;
        }
      });
    });
  }

  @override
  void initState() {
    getUserLoggedInState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BRAINY',
        debugShowCheckedModeBanner: false,
        home: _connectionStatus == 'ConnectivityResult.none'
            ? MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      height: 90.0,
                      color: Color(0xFFffa7a1),
                      child: Center(
                        child: Text(
                          "No Internet Connection Found",
                          style: TextStyle(
                              color: Color(0xFF470500), fontWeight: FontWeight.bold, fontSize: 25.0),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : userLoggedInState
                ? Menu()
                : SignUp());
  }
}
