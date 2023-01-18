import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/categories_full.dart';
// import '../widgets/background_image.dart';
import '../widgets/rounded_button.dart';
import '../widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // final _auth = FirebaseAuth.instance;

  var refCategories = FirebaseDatabase.instance.ref().child("Category");

  // String email;
  // String password;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.text = "saicharan@gmail.com";
    passwordController.text = "123456";
  }

  _showSnackBar(String message, Color color) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFCC80),
      key: _scaffoldKey,
      body: Stack(
        children: [
          //backgroundimage(screenSize: screenSize),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Hero(
                  tag: 'logo ',
                  child: Container(
                    height: 100.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: emailController,
                  autocorrect: false,
                  autofocus: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 17.0,
                ),
                RoundedButton(
                  title: 'LOGIN',
                  colour: Colors.blue,
                  onPressed: () async {
                    try {
                      final user = (await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim()))
                          .user;
                      if (user != null) {
                        _showSnackBar("Successful", Colors.green);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesFull(
                                    refCategories: refCategories,
                                  )),
                          ModalRoute.withName('/'),
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
