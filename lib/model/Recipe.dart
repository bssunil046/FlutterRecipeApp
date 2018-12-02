//  This is DataModel class for recipe.
import 'package:firebase_database/firebase_database.dart';

class Recipe {
  String _id;
  String _title;
  String _ingredients;
  String _description;

  Recipe(this._id, this._title, this._ingredients, this._description);

  String get id => _id;

  String get title => _title;

  String get ingredients => _ingredients;

  String get description => _description;

  Recipe.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _title = snapshot.value['title'];
    _ingredients = snapshot.value['ingredients'];
    _description = snapshot.value['description'];
  }
}
