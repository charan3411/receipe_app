import 'package:receipe_app/screens/DetailsPage.dart';

import '../model/food.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../widgets/Foodcardwidget.dart';


class MealsPage extends StatefulWidget {
  var Categorie;
  bool searchState = false;
  MealsPage({required this.Categorie, required this.searchState});

  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  var refMeals = FirebaseDatabase.instance.ref().child("Meals");
  bool searchState = false;
  String searchWord = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: searchState
            ? TextField(
          decoration: InputDecoration(
            hintText: "Search Something..",
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (resultSearch) {
            print("Conclusion : $resultSearch");
            setState(() {
              searchWord = resultSearch;
            });
          },
        )
            : Text("Categorie : ${widget.Categorie.Categorie_ad}"),
        actions: [
          searchState
              ? IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  searchState = false;
                  searchWord = "";
                });
              })
              : IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  searchState = true;
                });
              }),
        ],
      ),
      body: StreamBuilder<dynamic>(
        stream: refMeals
            .orderByChild("Categorie_ad")
            .equalTo(widget.Categorie.Categorie_ad)
            .onValue,
        builder: (context, event) {
          if (event.hasData) {
            var MealsPageLists = <Meals>[];

            var incomingValues = event.data.snapshot.value;

            if (incomingValues != null) {
              incomingValues.forEach((key, article) {
                var incomingfood = Meals.fromJson(key, article);
                if (searchState) {
                  if (incomingfood.Material.contains(searchWord) |
                  incomingfood.food_adi.contains(searchWord)) {
                    MealsPageLists.add(incomingfood);
                  }
                } else {
                  MealsPageLists.add(incomingfood);
                }
              });
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2 / 1,
              ),
              itemCount: MealsPageLists.length,
              itemBuilder: (context, index) {
                var food = MealsPageLists[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                              food: food,
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FoodCardWidget(food: food, screenSize: Size.square(0.0),),
                  ),
                );
              },
            );
          } else {
            return Center();
          }
        },
      ),
    );
  }
}
