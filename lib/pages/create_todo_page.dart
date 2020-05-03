import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/persistence/todo_table.dart';
import 'package:task_manager/providers/category_dropdown_provider.dart';
import 'package:task_manager/providers/category_provider.dart';
import 'package:task_manager/providers/color_theme_provider.dart';
import 'package:task_manager/stores/task_store.dart';
import 'package:task_manager/models/task_model.dart';

import 'package:task_manager/widgets/category_dropdown.dart';

import 'category_creation/create_category_first_step_page.dart';

class CreateTodoPage extends StatefulWidget {
  CreateTodoPage({Key key}) : super(key: key);

  @override
  _CreateTodoPageState createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  final _formKey = GlobalKey<FormState>();
  String category;
  String name;
  String description;

  @override
  Widget build(BuildContext context) {
    MyDatabase databaseProvider = Provider.of<MyDatabase>(context);
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    categoryProvider.injectDatabaseProvider(databaseProvider);
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
    final MyDatabase databaseProvider =
        Provider.of<MyDatabase>(context, listen: false);

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
              CategoryDropdown(),
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
                  // taskStore.add(Task(
                  //     id: 1,
                  //     category: "whatever",
                  //     name: name,
                  //     description: description,
                  //     done: false));
                      taskStore.add(Task(id:1, category: category, name: name, description: description, done:false));
                  // var category = categoryDropdownProvider.category;

                  // databaseProvider.getCategoryById(category).then((result) => {
                  //       category = result[0].id,
                  //     });

                  // databaseProvider.addTodo(Todo(
                  //     name: name,
                  //     description: description,
                  //     done: false,
                  //     category: category));
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
}
