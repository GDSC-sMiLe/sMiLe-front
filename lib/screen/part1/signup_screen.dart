import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smile_front/screen/part2/home_screen.dart';
import '../../config/palette.dart';
import '/firebase_options.dart';
import 'package:intl/intl.dart';

import './depression_diagnosis_selection_screen.dart';

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;
  late String name;
  late int flag = 0;
  late int userScore;
  late List<String> medications;
  late bool _complete1 = false;
  late bool _complete2 = false;
  late bool _complete3 = false;
  late bool _complete4 = false;
  late bool _complete5 = false;
  late bool _complete6 = false;

  late String _dt1 = "";
  late String _dt2 = "";
  late String _dt3 = "";
  late String _dt4 = "";
  late String _dt5 = "";
  late String _dt6 = "";
  late int _mission1 = 0;
  late int _mission2 = 0;
  late int _mission3 = 0;
  late int _mission4 = 0;
  late int _mission5 = 0;
  late int _mission6 = 0;
  late String _userImage;
  bool isInput = true;
  bool isSignIn = true;

  getUser() async {
    final DateTime now = DateTime.now();
    final String nowStr = DateFormat('yy-MM-dd').format(now);
    DocumentSnapshot _userDoc =
    await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (_userDoc.exists) {
      Map<String, dynamic> userData = _userDoc.data() as Map<String, dynamic>;
      email = userData['userInfo'];
      name = userData['userName'];
      userScore = userData['userScore'];
      medications = List<String>.from(userData['medications']);
      _complete1 = userData['complete1'] ?? false;
      _complete2 = userData['complete2'] ?? false;
      _complete3 = userData['complete3'] ?? false;
      _complete4 = userData['complete4'] ?? false;
      _complete5 = userData['complete5'] ?? false;
      _complete6 = userData['complete6'] ?? false;
      _dt1 = userData['dt1'] ?? "";
      _dt2 = userData['dt2'] ?? "";
      _dt3 = userData['dt3'] ?? "";
      _dt4 = userData['dt4'] ?? "";
      _dt5 = userData['dt5'] ?? "";
      _dt6 = userData['dt6'] ?? "";
      _mission1 = userData['mission1'] ?? 0;
      _mission2 = userData['mission2'] ?? 0;
      _mission3 = userData['mission3'] ?? 0;
      _mission4 = userData['mission4'] ?? 0;
      _mission5 = userData['mission5'] ?? 0;
      _mission6 = userData['mission6'] ?? 0;
      _userImage = userData['userImage'] ?? "asset/img/smileimoge.png";

      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString('userInfo', email);
      _prefs.setString('userName', name);
      _prefs.setInt('userScore', userScore);
      _prefs.setStringList('medications', medications);
      if (nowStr == _dt1) {
        _prefs.setBool('complete1', _complete1);
      } else {
        _prefs.setBool('complete1', false);
      }
      if (nowStr == _dt2) {
        _prefs.setBool('complete2', _complete2);
      } else {
        _prefs.setBool('complete2', false);
      }
      if (nowStr == _dt3) {
        _prefs.setBool('complete3', _complete3);
      } else {
        _prefs.setBool('complete3', false);
      }
      if (nowStr == _dt4) {
        _prefs.setBool('complete4', _complete4);
      } else {
        _prefs.setBool('complete4', false);
      }
      if (nowStr == _dt5) {
        _prefs.setBool('complete5', _complete5);
      } else {
        _prefs.setBool('complete5', false);
      }
      if (nowStr == _dt6) {
        _prefs.setBool('complete6', _complete6);
      } else {
        _prefs.setBool('complete6', false);
      }
      _prefs.setString('dt1', _dt1);
      _prefs.setString('dt2', _dt2);
      _prefs.setString('dt3', _dt3);
      _prefs.setString('dt4', _dt4);
      _prefs.setString('dt5', _dt5);
      _prefs.setString('dt6', _dt6);
      _prefs.setInt('mission1', _mission1);
      _prefs.setInt('mission2', _mission2);
      _prefs.setInt('mission3', _mission3);
      _prefs.setInt('mission4', _mission4);
      _prefs.setInt('mission5', _mission5);
      _prefs.setInt('mission6', _mission6);
      _prefs.setString('userImage', _userImage);
      flag = 1;
    } else {
      flag = 0;
    }
  }

  signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {

        if (value.user!.emailVerified) {
          setState(() {
            isInput = false;
          });
        } else {
          showToast('emailVerified error');
        }
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('user-not-found');
      } else if (e.code == 'wrong-password') {
        showToast('wrong-password');
      } else {
        print(e.code);
      }
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      isInput = true;
    });
  }

  signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user!.email != null) {
          FirebaseAuth.instance.currentUser?.sendEmailVerification();
          setState(() {
            isInput = false;
          });
        }
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('weak-password');
      } else if (e.code == 'email-already-in-use') {
        showToast('email-already-in-use');
      } else {
        showToast('other error');
        print(e.code);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget getInputWidget() {
    return Center(
      child: Column(children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          child: Text(
            isSignIn ? "SignIn" : "SignUp",
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 350,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Please enter email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    email = value ?? "";
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 350,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Please enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    password = value ?? "";
                  },
                ),
              ),

              SizedBox(height: 20),
              Container(
                width: 200.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      if (isSignIn) {
                        signIn();
                        getUser();
                      } else {
                        signUp();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Palette.bgColor,
                  ),
                  child: Text(isSignIn ? "SignIn" : "SignUp"),
                ),
              ),
              SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  text: 'Go ',
                  style: TextStyle(color: Palette.bgColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: isSignIn ? "SignUp" : "SignIn",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              isSignIn = !isSignIn;
                            });
                          }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget getResultWidget() {
    String resultEmail = FirebaseAuth.instance.currentUser!.email!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding( // 텍스트에 패딩 추가
            padding: const EdgeInsets.all(8.0),
            child: Text(
              isSignIn
                  ? "You are signed in with $resultEmail!"
                  : "You have signed up with $resultEmail! Please verify your email to log in.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (isSignIn && flag == 0) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                prefs.setString('userInfo', resultEmail);
                prefs.setString('userName', resultEmail.split('@')[0]);
                print(prefs.get('userInfo'));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DepressionDiagnosisSelectionScreen()),
                );
              } else if (isSignIn && flag == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else {
                setState(() {
                  isInput = true;
                  isSignIn = true;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Palette.bgColor,
              textStyle: TextStyle(
                fontSize: 16,
              ),
            ),
            child: Text(isSignIn ? "Start" : "Sign In"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Back', style: TextStyle(color: Colors.black)),
          ),
          title: Center(
            child: Image.asset(
              'asset/img/smileimoge.png',
              height: 40,
            ),
          ),
          actions: [
            Opacity(
                opacity: 0.0,
                child: TextButton(onPressed: () {}, child: Text('Back')))
          ],
        ),
        body: isInput ? getInputWidget() : getResultWidget());
  }

  void _signup() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DepressionDiagnosisSelectionScreen()),
    );
  }
}
