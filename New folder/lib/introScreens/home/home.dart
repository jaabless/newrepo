import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:introfirebase/introScreens/home/messageList.dart';
import 'package:introfirebase/introServices/auth.dart';
import 'package:introfirebase/introServices/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:introfirebase/introScreens/home/messageList.dart';
// import 'package:introfirebase/pg/loading.dart';

class homeAuth extends StatefulWidget {
  @override
  _homeAuthState createState() => _homeAuthState();
}

class _homeAuthState extends State<homeAuth> {
  final emailController = TextEditingController();
  // final passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  String errorMessage = '';
  bool isLoading = false;
  bool _toogleVisibility = true;
  String erMsg = " ";
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference messages =
        FirebaseFirestore.instance.collection('messages');

    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService(uid: '').users,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          elevation: 0.0,
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await AuthService().signOut();
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: StreamBuilder(
                    stream: messages.orderBy('message').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('Loading..'));
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((userMessage) {
                          return Center(
                            child: ListTile(
                              title: Text(userMessage['message']),
                              onLongPress: () {
                                userMessage.reference.delete();
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }),
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 2.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  // First child is enter comment text input
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter Your Email',
                        ),
                      ),
                    ),
                  ),
                  // Second child is button
                  IconButton(
                    icon: Icon(Icons.send),
                    iconSize: 20.0,
                    onPressed: () {
                      messages.add({
                        'message': emailController.text,
                      });
                      emailController.clear();
                    },
                  )
                ])),
          ],
        ),
      ),
    );
  }
}
