import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/model/todo_model.dart';
import 'package:task_manager/providers/todo_provider.dart';

class TodoPage extends StatefulWidget {
  TodoPage(this.title, this.todo);
  final String title;
  final TodoModel todo;

  @override
  _TodoPageState createState() => _TodoPageState(todo);
}

class _TodoPageState extends State<TodoPage> {
  _TodoPageState(this.todo);
  TodoModel todo;

  @override
  Widget build(BuildContext context) {
    final TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: buildTodoInfoSection(todoProvider, context),
    );
  }

  Column buildTodoInfoSection(TodoProvider todoProvider, BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            todo.name,
            style: TextStyle(fontSize: 36),
          ),
        ),
        _buildCircleAvatar(todo),
        buildCategoryText(),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Container(
              height: 300,
              child: buildDescriptionText(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: buildTodoButtons(todoProvider, context),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.greenAccent[700],
      title: Text(todo.name),
    );
  }

  List<Widget> buildTodoButtons(
      TodoProvider todoProvider, BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () => {
          todo.done
              ? todoProvider.saveAsNotDone(todo)
              : todoProvider.saveAsDone(todo),
        },
        icon: Icon(Icons.done),
        color: todo.done ? Colors.green : Colors.indigo,
      ),
      IconButton(
          onPressed: () => {todoProvider.remove(todo), Navigator.pop(context)},
          icon: Icon(Icons.delete)),
    ];
  }

  Text buildDescriptionText() {
    return Text(
      todo.description,
      style: GoogleFonts.ibarraRealNova(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        textStyle: TextStyle(letterSpacing: .5),
      ),
    );
  }

  Text buildCategoryText() {
    return Text(
      todo.category,
      style: GoogleFonts.ibarraRealNova(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        textStyle: TextStyle(letterSpacing: .5),
      ),
    );
  }

//TODO:Fix this, a todo must have a category and a category must have an image
  CircleAvatar _buildCircleAvatar(TodoModel todo) {
    String imageUrl = '';
    if (todo.category == 'Work') {
      imageUrl =
          'https://images.unsplash.com/photo-1494498902093-87f291949d17?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60';
    } else if (todo.category == 'Study') {
      imageUrl =
          'https://images.unsplash.com/photo-1537202108838-e7072bad1927?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=685&q=80';
    } else {
      imageUrl =
          'https://images.unsplash.com/photo-1462926703708-44ab9e271d97?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=564&q=80';
    }

    return CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
      radius: 80,
    );
  }
}
