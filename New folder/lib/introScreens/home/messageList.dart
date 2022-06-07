import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:introfirebase/introScreens/home/messageTile.dart';

class messageList extends StatefulWidget {
  const messageList({Key? key}) : super(key: key);

  @override
  State<messageList> createState() => _messageListState();
}

class _messageListState extends State<messageList> {
  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<QuerySnapshot?>(context);
    for (var doc in messages!.docs) {
      print(doc.data);
    }
    return Container();
  }
}
