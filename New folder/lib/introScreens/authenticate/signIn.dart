import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:introfirebase/pg/loading.dart';
import 'package:introfirebase/introServices/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  // final passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;
  bool _toogleVisibility = true;
  String erMsg = " ";

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return isLoading
        ? Loading()
        : MaterialApp(
            home: Scaffold(
            appBar: AppBar(
              title: Text(
                  'SIgn In (Logged ' + (user == null ? 'out' : 'in') + ')'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Sign Up'),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: Form(
              key: _key,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter Your Email',
                        ),
                        validator: validateEmail,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: _toogleVisibility,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _toogleVisibility = !_toogleVisibility;
                              });
                            },
                            icon: _toogleVisibility
                                ? const Icon(
                                    Icons.visibility_off,
                                    size: 20,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    size: 20,
                                  ),
                          ),
                          labelText: 'Password',
                          hintText: 'Enter Password',
                        ),
                        validator: validatePassword,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(erMsg, style: TextStyle(color: Colors.red)),
                        // child: showToastMessage(errorMessage),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            child: Text('Sign In'),
                            onPressed: user != null
                                ? null
                                : () async {
                                    // if (_key.currentState!.validate()) {
                                    //   setState(() => isLoading = true);
                                    //   dynamic result = await FirebaseAuth
                                    //       .instance
                                    //       .signInWithEmailAndPassword(
                                    //     email: emailController.text,
                                    //     password: passwordController.text,
                                    //   );
                                    //   if (result == null) {
                                    //     setState(() {
                                    //       isLoading = false;
                                    //       errorMessage =
                                    //           'Could not sign in with those credentials';
                                    //     });
                                    //   }
                                    // }
                                    // setState(() {
                                    //   isLoading = true;
                                    //   errorMessage = '';
                                    // });
                                    if (_key.currentState!.validate()) {
                                      try {
                                        setState(() => isLoading = true);
                                        dynamic result = await AuthService()
                                            .signInWithEmailAndPassword(
                                          emailController.text,
                                          passwordController.text,
                                        );
                                        if (result == null) {
                                          erMsg =
                                              "This user does not exit. Please Sign Up!";
                                        }
                                      } on FirebaseAuthException catch (error) {
                                        errorMessage = "Could not Sign In";
                                        erMsg =
                                            "Please check credentials and Network";
                                      }

                                      setState(() => isLoading = false);
                                    }
                                  }),
                      ],
                    ),
                    Center(
                      child: showToastMessage(errorMessage),
                    )
                  ],
                ),
              ),
            ),
          ));
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty)
    return 'E-mail address is required.';

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty)
    return 'Password is required.';

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword))
    return '''
      Password must be at least 8 characters,
      include an uppercase letter, number and symbol.
      ''';

  return null;
}

showToastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 73, 73, 73),
      textColor: Colors.white,
      fontSize: 16.0);
}
