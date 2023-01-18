import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/google_sign.dart';
import 'package:firebase_database/firebase_database.dart';
import '../screens/CategoriesPage.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  var refCategories = FirebaseDatabase.instance.ref().child("Categorie");
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () async {
          try {
            final user = (await signInGoogle()).user;
            if (user != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoriesPage(
                        refCategories: refCategories,
                          )));
            }
          } catch (e) {
            print(e);
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage("images/google.png"),
                height: 30,
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Sign in with Google",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
