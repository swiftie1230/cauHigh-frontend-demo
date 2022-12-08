import 'package:flutter/material.dart';

import '';

class DB {
  static void errorCode(int code, BuildContext context) {
    String result = "";
    switch (code) {
      case 200:
        result = "$code : 성공";
        break;
      case 201:
        result = "$code : 생성됨";
        break;
      case 204:
        result = "$code : 비어있음";
        break;
      case 401:
        result = "$code : 권한없음";
        break;
      case 404:
        result = "$code : Not Found";
        break;
      case 500:
        result = "$code : 서버에 문제가 생겼습니다.";
        break;
      default:
        result = "error code: $code";
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(result),
          actions: <Widget>[
            TextButton(
              child: const Text("닫기"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
