import 'package:flutter/material.dart';

class SnackBarService {
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String value) {
    scaffoldKey.currentState?.hideCurrentSnackBar();
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(value)));
  }
}
