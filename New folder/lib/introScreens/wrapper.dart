import 'package:introfirebase/modelsNinja/user.dart';
import 'package:introfirebase/introScreens/authenticate/authenticate.dart';
import 'package:introfirebase/introScreens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<mainUser?>(context);
    print(user);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return homeAuth();
    }
  }
}
