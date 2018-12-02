import 'package:flutter/material.dart';
import 'package:recipe_app/model/Recipe.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recipe_app/ui/recipe_screen.dart';
import 'dart:async';

/// This class implements the screen to list all recipes.
/// It fetches the recipes from firebase.
/// Upon tapping a add button or a list item, it will be navigated to recipe screen, where details of recipe is shown.

class RecipeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ListViewState();
}

const String table_recipe = 'recipes';
const String ROW_TITLE = 'title';
const String ROW_INGREDIENTS = 'ingredients';
const String ROW_DESC = 'description';

final recipeReference =
    FirebaseDatabase.instance.reference().child(table_recipe);

class _ListViewState extends State<RecipeApp> {
  List<Recipe> items;
  StreamSubscription<Event> _onRecipeAddedSubscription;
  StreamSubscription<Event> _onRecipeChangedSubscription;

  @override
  void initState() {
    super.initState();

    //  On the launch of this screen, fetch all the recipes from firebase database.
    items = new List();
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child(table_recipe).once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      for (var key in keys) {
        items.add(new Recipe(key, data[key][ROW_TITLE],
            data[key][ROW_INGREDIENTS], data[key][ROW_DESC]));
      }
    });
    _onRecipeAddedSubscription =
        recipeReference.onChildAdded.listen(_onRecipeAdded);
    _onRecipeChangedSubscription =
        recipeReference.onChildAdded.listen(_onRecipeUpdated);
  }

  @override
  void dispose() {
    _onRecipeAddedSubscription.cancel();
    _onRecipeChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Recipe App',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Receipe App'),
            backgroundColor: Colors.blue,
          ),
          body: Center(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Text('${items[position].title}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          )),
                      subtitle: Text('${items[position].ingredients}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          )),
                      onTap: () => _navigateToRecipe(context, items[position]),
                    ),
                  ],
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _createNewRecipe(context)),
        ));
  }

  void _onRecipeAdded(Event event) {
    setState(() {
      items.add(new Recipe.fromSnapshot(event.snapshot));
    });
  }

  void _onRecipeUpdated(Event event) {
    var oldValue =
        items.singleWhere((recipe) => recipe.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldValue)] = new Recipe.fromSnapshot(event.snapshot);
    });
  }

  void _navigateToRecipe(BuildContext context, Recipe recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeScreen(recipe)),
    );
  }

  void _createNewRecipe(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RecipeScreen(Recipe(null, null, null, null))));
  }
}
