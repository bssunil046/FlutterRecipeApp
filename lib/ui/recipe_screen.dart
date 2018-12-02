import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recipe_app/model/Recipe.dart';

/// This class implements the screen to add a new recipe.
/// It is also used to show an existing recipe and it can be changed.
class RecipeScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeScreen(this.recipe);

  @override
  State<StatefulWidget> createState() => new _RecipeScreenState();
}

final recipeReference = FirebaseDatabase.instance.reference().child('recipes');

class _RecipeScreenState extends State<RecipeScreen> {
  TextEditingController _titleController;
  TextEditingController _ingredientsController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = new TextEditingController(text: widget.recipe.title);
    _ingredientsController =
        new TextEditingController(text: widget.recipe.ingredients);
    _descriptionController =
        new TextEditingController(text: widget.recipe.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe')),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            //  Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),

            //  Ingredients
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),

            //  Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),

            //  Add/Update button
            RaisedButton(
              child: (widget.recipe.id != null) ? Text('Update') : Text('Add'),
              onPressed: () => onButtonPressed(),
            ),
          ],
        ),
      ),
    );
  }

  ///  This method handles the button press.
  ///  It checks if its a new recipe or existing recipe, base on which the text
  ///  on the button will change and corresponding firebase operations is done.
  void onButtonPressed() {
      if (widget.recipe.id != null) {
        recipeReference.child(widget.recipe.id).set({
          'title': _titleController.text,
          'ingredients': _ingredientsController.text,
          'description': _descriptionController.text
        }).then((_) {
          Navigator.pop(context);
        });
      } else {
        recipeReference.push().set({
          'title': _titleController.text,
          'ingredients': _ingredientsController.text,
          'description': _descriptionController.text
        }).then((_) {
          Navigator.pop(context);
        });
      }
    }
}
