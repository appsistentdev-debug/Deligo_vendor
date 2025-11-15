import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      webPosition: "top",
      gravity: ToastGravity.TOP,
    );
