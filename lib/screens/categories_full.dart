import 'package:flutter/material.dart';
import 'CategoriesPage.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoriesFull extends StatelessWidget {
  final DatabaseReference refCategories;

  const CategoriesFull({Key? key, required this.refCategories}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //backgroundColor: Color(0xFFFFCC80),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.orange,
          title: Center(
            child: Text(
              'Please Choose in the List',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: CategoriesPage(refCategories: refCategories),
      ),
    );
  }
}
