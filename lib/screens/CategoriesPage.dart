import 'dart:convert';
import 'dart:core';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:receipe_app/screens/MealsPage.dart';
import '../model/Categories.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/categorycardwidget.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    Key? key,
    required this.refCategories,
  }) : super(key: key);

  final DatabaseReference refCategories;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: refCategories.onValue,
      builder: (context, event) {
        if (event.hasData) {
          List<Categorie> categoryList = event.data!.snapshot.children
              .map((e) => Categorie.fromJson(
                  DateTime.now().millisecondsSinceEpoch.toString(),
                  jsonDecode(jsonEncode(e.value))))
              .toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 2,
            ),
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              var Categorie = categoryList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MealsPage(
                                Categorie: Categorie,
                                searchState: FormData.supported!,
                              )));
                },
                child: CategoryCard(Categorie: Categorie),
              );
            },
          );
        } else {
          return Center();
        }
      },
    );
  }
}
