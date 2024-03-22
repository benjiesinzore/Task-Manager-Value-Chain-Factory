import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/strings.dart';

class SharedWidgets {
  static final SharedWidgets instance = SharedWidgets.internal();

  factory SharedWidgets() {
    return instance;
  }

  SharedWidgets.internal();

  void showPopup(BuildContext context, String title, String description, int id, String toastTo) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        var screenWidth = MediaQuery.of(context).size.width;

        var dialogWidth = screenWidth;

        Future.delayed(const Duration(seconds: 1), () {

          Navigator.of(context).pop();
          _showToast(id, toastTo);
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizedBox(
            width: dialogWidth,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(title, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  Text(description),
                  const SizedBox(height: 30),
                  const LinearProgressIndicator(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _showToast(int id, String toastTo) {
    String toastMsg;
    if (toastTo == stringUpdateTask) {
      toastMsg = "$toastMsgUpdateSuccess$id";
    } else if (toastTo == stringDeleteTask) {
      toastMsg = "$toastMsgDeleteSuccess$id";
    } else {
      toastMsg = "$toastMsgAddSuccess$id";
    }

    Fluttertoast.showToast(
      msg: toastMsg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

}
