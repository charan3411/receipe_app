import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rating_bar/rating_bar.dart';

import '../model/food.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  Meals food;

  DetailPage({required this.food});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late double _rating;
  List<Meals> foodList = [];
  int ratedCheck = 0;
  String streamGelenRate = "";

  final name = "star_rate";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Definition of lentils" + widget.food.food_id);
    var FirebaseFirestore;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.food.food_adi),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  child: Image.network(
                    widget.food.picture,
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Preparation Time: ${widget.food.Time}" + "dk"),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      starButton(context),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("meals")
                              .doc(widget.food .food_id)
                              .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              var incomeData = snapshot.data;
                              // Meals food = Meals.fromMap(jsonDecode(jsonEncode(incomeData!.data())));
                              var food = Meals.fromMap(jsonDecode(jsonEncode(incomeData))?.data());

                              String rate = rateCreate(food);
                              streamGelenRate = rate;
                              return Text(rate);
                            } else {
                              return SizedBox();
                            }
                          })
                    ],
                  ),
                )
              ]),
              SizedBox(
                height: 10,
              ),
              TextS(
                name: "MATERIALS",
              ),
              Text(
                widget.food.Material,
                style: TextStyle(),
              ),
              SizedBox(
                height: 10,
              ),
              TextS(
                name: "RECIPE",
              ),
              Text(widget.food.Rates),
              SizedBox(
                height: 10,
              ),
              TextS(
                name: "SUGGESTIONS",
              ),
              SizedBox(
                  height: 15.0,
                  width: 100.0,
                  child: Divider(
                    color: Colors.orange,
                    thickness: 1,
                  )),
              Container(
                height: 190,
                color: Colors.transparent,
                child: StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref()
                      .child("Meals")
                      .orderByChild("star_rate")
                      .equalTo("5")
                      .limitToFirst(50)
                      .onValue,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      List<Meals> dishesPageList = <Meals>[];

                      var gelenDegerler = snapshot.data.snapshot.value;

                      if (gelenDegerler != null) {
                        gelenDegerler.forEach((key, value) {
                          var incomingfood = Meals.fromJson(key, value);

                          if (incomingfood.Categorie_ad ==
                              widget.food.Categorie_ad &&
                              incomingfood.food_adi != widget.food.food_adi) {
                            // print(incomingfood.Categorie_ad);
                            dishesPageList.add(incomingfood);
                          }
                        });

                        print(dishesPageList.length);
                        foodList = dishesPageList;
                        dishesPageList.shuffle();

                      }
                      return GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dishesPageList.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, crossAxisSpacing: 1),
                          itemBuilder: (BuildContext context, int index) {
                            return Trialcard(
                                food: dishesPageList[index]);
                          });
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton starButton(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.star,
          color: Colors.yellowAccent[700],
          size: 31,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Rate the food :)"),
                  actions: [
                    RatingBar(
                      onRatingChanged: (rating) {
                        setState(() {
                          _rating = rating;
                          ratedCheck++;
                        });
                      },
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_border,
                      halfFilledIcon: Icons.star_half,
                      isHalfAllowed: false,
                      filledColor: Colors.yellow,
                      emptyColor: Colors.grey,
                      halfFilledColor: Colors.amberAccent,
                      size: 48,
                    ),
                    SizedBox(height: 32),
                    /*Text(
                      'Rating : $streamGelenRate',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),*/
                    TextButton(
                        onPressed: () async {
                          if (ratedCheck == 1) {
                            try {
                              print(
                                  "The food id to update the rate ${widget.food.food_id}: food adi${widget.food.food_adi}");

                              await FirebaseFirestore.instance
                                  .collection("meals")
                                  .doc(widget.food.food_id)
                                  .update({
                                "rating":
                                FieldValue.arrayUnion([_rating.toInt()])
                              });
                            } catch (e) {
                              print(e);
                            }

                            Fluttertoast.showToast(
                                msg:
                                "Congratulations 🎉🎉🎉 for Rating ${_rating.toInt().toString()} you gave star",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 4,
                                backgroundColor: Colors.white,
                                textColor: Colors.blue[800],
                                fontSize: 16.0);

                            Navigator.of(context).pop();
                          } else if (ratedCheck > 1) {
                            print("rate has been done");
                            Fluttertoast.showToast(
                                msg: "You've already starred the recipe !!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 4,
                                backgroundColor: Colors.grey[800],
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Finish"))
                  ],
                );
              });
        });
  }

  ratingCreate() async {
    List newList = [];

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("meals")
        .doc(widget.food.food_id)
        .get();

    Meals food = Meals.fromMap(jsonDecode(jsonEncode(documentSnapshot.data())));

    newList = food.rating;
    print("new list $newList");
    print(newList.length);
    double ratingTotal = 0.0;
    double averageRating = 0.0;

    for (var i in newList) {
      print(ratingTotal);
      ratingTotal += i;
    }

    averageRating = ratingTotal / newList.length;
    print("average rating $averageRating");
    return averageRating;
  }

  rate() async {

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Meals")
        .doc(widget.food.food_id)
        .get();

    //var food = Meals.fromMap(documentSnapshot.data());
    Meals food = Meals.fromMap(jsonDecode(jsonEncode(documentSnapshot.data())));

    return food;
  }

  String rateCreate(Meals food) {
    double averageRating = 0.0;

    for (var i in food.rating) {
      averageRating += i;
    }
    averageRating = averageRating / food.rating.length;
    print("Average Rating and Length of Meal List How Many Votes are there");
    print(food.rating.length);
    print("Average Rating");
    print(averageRating);

    return averageRating.toStringAsFixed(2);
  }
}

class TextS extends StatelessWidget {
  final String name;

  const TextS({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      height: 20,
    );
  }
}

class Trialcard extends StatelessWidget {
  Meals food;

  Trialcard({required this.food});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                  food: food,
                )));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.all(1),
              height: 180,
              width: 180,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  children: [
                    Image.network(
                      this.food.Rates,
                      height: 120,
                      filterQuality: FilterQuality.high,
                      // fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(this.food.food_adi)
                  ],
                ),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
      ),
    );
  }
}
