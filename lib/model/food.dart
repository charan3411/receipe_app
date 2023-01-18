class Meals {
  String food_id;
  String food_adi;
  int Time;
  String star_rate;
  String star_counter;
  String star_total;
  String picture;
  String Categorie_ad;
  String Rates;
  String Material;
  List rating;

  Meals(
      this.food_id,
      this.food_adi,
      this.Time,
      this.picture,
      this.Categorie_ad,
      this.Rates,
      this.Material,
      this.star_counter,
      this.rating,
      this.star_rate,
      this.star_total);

  factory Meals.fromJson(String key, Map<dynamic, dynamic> json) {
    return Meals(
      key,
      json["food_adi"] as String,
      json["Time"] as int,
      json["picture"] as String,
      json["Categorie_ad"] as String,
      json["Rates"] as String,
      json["Material"] as String,
      json["star_counter"] as String,
      json["rating"] as List,
      json["star_rate"] as String,
      json["food_id"] as String,
    );
  }

  Meals.fromMap(Map<dynamic, dynamic> map)
      : food_adi = map['foodAdi'],
        food_id = map['id'],
        Time = map['Time'],
        Material = map['Material'],
        rating = map['rating'],
        Categorie_ad = map['Categorie'],
        picture = map['picture'],
        star_counter = map[''],
        star_rate = map[''],
        star_total = map[''],
        Rates = map['Rates'];

  @override
  String toString() {
    // TODO: implement toString
    return 'Meals ; Food adi : $food_adi ,foodID :$food_id, rating: $rating ,Time : $Time , gorsel : $picture , Categorie adı :$Categorie_ad , Rates : $Rates , Material :$Material ,';
  }
}
