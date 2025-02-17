// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use
// import 'dart:async';
// import 'dart:convert';

// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String userIdValue = "";
  String userEmailValue = "";
  String userPwdValue = "";

  void _registerRequest(userIdValue, userEmailValue, userPwdValue) async {
    // String url = 'http://ec2-44-242-141-79.us-west-2.compute.amazonaws.com:9090/api/auth/signup';

    var data = jsonEncode({
      "name": userIdValue,
      "email": userEmailValue,
      "password": userPwdValue
    });

    http.Response response = await http.post(
      Uri(
        scheme: 'http',
        host: 'ec2-44-242-141-79.us-west-2.compute.amazonaws.com',
        port: 9090,
        path: 'api/auth/signup',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: data,
    );

    if (response.statusCode == 200) {
      print("Register Success !");
    } else if (response.statusCode == 400) {
      print('Register FAIL');
      throw Exception('Register FAIL');
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode1 = new FocusNode();
    FocusNode myFocusNode2 = new FocusNode();
    FocusNode myFocusNode3 = new FocusNode();
    return MaterialApp(
      home: Scaffold(
        body: Container(
          margin: EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                margin: EdgeInsets.only(
                  left: 10,
                  bottom: 5,
                ),
                alignment: Alignment(-1.0, 0.0),
                child: Text(
                  'REGISTER',
                  style: TextStyle(
                    color: const Color(0xff3D5D54),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 15,
                margin: EdgeInsets.only(left: 10),
                alignment: Alignment(-1.0, 0.0),
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                height: 50,
                // width: 335,
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      userIdValue = text;
                    });
                  },
                  focusNode: myFocusNode1,
                  decoration: InputDecoration(
                    labelText: 'ID / Nickname',
                    labelStyle: TextStyle(
                        fontSize: 14,
                        color: myFocusNode1.hasFocus
                            ? Colors.grey
                            : Colors.grey //Color.fromARGB(255, 122, 173, 159),
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: const Color(0xff3D5D54),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color:
                              Colors.grey, //Color.fromARGB(255, 122, 173, 159),
                          /*Color(0xFFE4F0ED),*/ width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 50,
                // width: 300,
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      userEmailValue = text;
                    });
                  },
                  focusNode: myFocusNode2,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    labelStyle: TextStyle(
                        fontSize: 14,
                        color: myFocusNode2.hasFocus
                            ? Colors.grey
                            : Colors.grey //Color.fromARGB(255, 122, 173, 159),
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: const Color(0xff3D5D54),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color:
                              Colors.grey, //Color.fromARGB(255, 122, 173, 159),
                          width: 2.0),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                // width: 300,
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      userPwdValue = text;
                    });
                  },
                  focusNode: myFocusNode3,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Create Password',
                    labelStyle: TextStyle(
                        fontSize: 14,
                        color: myFocusNode3.hasFocus
                            ? Colors.grey
                            : Colors.grey //Color.fromARGB(255, 122, 173, 159),
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: const Color(0xff3D5D54),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color:
                              Colors.grey, //Color.fromARGB(255, 122, 173, 159),
                          width: 2.0),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 5,
                ),
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff3D5D54),
                    // textColor: Colors.white,
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  // name instead of the actual result! : without parentheses
                  onPressed: () => {
                    _registerRequest(userIdValue, userEmailValue, userPwdValue),
                    print('[Register Screen] Clicked Register Button')
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '계정이 이미 있으신가요?',
                    style: TextStyle(color: Colors.blueGrey),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    child: Text(
                      '로그인',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 122, 173, 159),
                      ),
                    ),
                    // name instead of the actual result! : without parentheses
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
