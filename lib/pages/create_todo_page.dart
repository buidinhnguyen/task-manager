import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
// import 'package:task_manager/persistence/todo_table.dart';
import 'package:task_manager/providers/category_dropdown_provider.dart';
import 'package:task_manager/providers/category_provider.dart';
import 'package:task_manager/providers/color_theme_provider.dart';
import 'package:task_manager/stores/store_category.dart';
import 'package:task_manager/stores/task_store.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/models/category_model.dart';

import 'package:task_manager/widgets/category_dropdown.dart';

import 'category_creation/create_category_first_step_page.dart';

class CreateTodoPage extends StatefulWidget {
  CreateTodoPage({Key key}) : super(key: key);

  @override
  _CreateTodoPageState createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  CategoryStore categoryStore;
  final _formKey = GlobalKey<FormState>();
  String category;
  String name;
  String description;

  @override
  Widget build(BuildContext context) {
    // MyDatabase databaseProvider = Provider.of<MyDatabase>(context);
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    // categoryProvider.injectDatabaseProvider(databaseProvider);
    ColorThemeProvider colorThemeProvider =
        Provider.of<ColorThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorThemeProvider.color == null
              ? Colors.green
              : colorThemeProvider.color.primaryColor,
          title: Text('Create todo'),
        ),
        body: Material(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _createTodoForm(context)),
        ),
      ),
    );
  }

  Form _createTodoForm(BuildContext context) {
    TaskStore taskStore = Provider.of<TaskStore>(context);

    final CategoryDropdownProvider categoryDropdownProvider =
        Provider.of<CategoryDropdownProvider>(context, listen: false);
    // final MyDatabase databaseProvider =
    //     Provider.of<MyDatabase>(context, listen: false);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Category:    ',
                style: TextStyle(fontSize: 16.0),
              ),
              Observer(builder: (_) => _createDropDown()),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.purpleAccent[700],
                onPressed: () => {_goToCreateCategoryPage(context)},
              )
            ],
          ),
          _createNameField(),
          _createDescriptionField(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  var category = Category(id: 1, name: "Personal");

                  taskStore.add(Task(
                      id: 1,
                      category: category,
                      name: name,
                      description: description,
                      done: false));

                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _createDescriptionField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Description',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a description'; //TODO: Description sometimes can be null
        }
        description = value;
        return null;
      },
    );
  }

  TextFormField _createNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Name',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a name';
        }
        name = value;
        return null;
      },
    );
  }

  Future _goToCreateCategoryPage(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateCategoryPage(),
        ));
  }

  DropdownButton _createDropDown() {
    return DropdownButton<String>(
      items: _createCategoriesList().toList(),
      onChanged: (newValue) {
        category = newValue;
      },
      underline: Container(
        height: 2,
        color: Colors.green,
      ),
      icon: Icon(Icons.arrow_downward),
      value: category != null ? category : "Personal",
    );
  }

  List<DropdownMenuItem<String>> _createCategoriesList() {
    List<DropdownMenuItem<String>> categoriesNames =
        List<DropdownMenuItem<String>>();
    if (categoryStore.categories != null) {
      categoryStore.categories.forEach((c) => {
            categoriesNames.add(DropdownMenuItem<String>(
              value: c.name,
              child: Text(
                c.name,
                style: new TextStyle(
                  fontSize: 12.0,
                  decoration: TextDecoration.none,
                ),
              ),
            )),
          });
    }
    return categoriesNames;
  }
}
