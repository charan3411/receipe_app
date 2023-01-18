class Categorie {
  String Categorie_id;
  String Categorie_ad;

  Categorie(this.Categorie_id, this.Categorie_ad);

  factory Categorie.fromJson(String key, Map<dynamic, dynamic> json) {
    return Categorie(key, json["Categorie_ad"] as String);
  }
}