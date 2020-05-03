import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/persistence/todo_table.dart';
import 'package:task_manager/providers/category_dropdown_provider.dart';
import 'package:task_manager/providers/category_provider.dart';
import 'package:task_manager/providers/color_theme_provider.dart';
import 'package:task_manager/providers/todo_provider.dart';
import 'package:task_manager/stores/task_store.dart';


import 'pages/home_page.dart';

void main() => runApp(MultiProvider(providers: [
      Provider(
        create: (_) => MyDatabase(),
      ),
      ChangeNotifierProxyProvider<MyDatabase, TodoProvider>(
          create: (_) => TodoProvider(),
          update: (_, myDatabase, todoProvider) => todoProvider),
      ChangeNotifierProvider<CategoryDropdownProvider>(
          create: (_) => CategoryDropdownProvider()),
      ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider()),
          ChangeNotifierProvider<ColorThemeProvider>(
          create: (_) => ColorThemeProvider()),
          Provider<TaskStore>(
          create: (_) => TaskStore())
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyDatabase databaseProvider = Provider.of<MyDatabase>(context);
    databaseProvider.insertInitialCategories();
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Home Page'),
    );
  }

}
