import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/task_model.dart';

abstract class ITodoRepository {
  FirebaseFirestore firestore;

  Stream<List<Task>> getTodos();

  void addTodo(Task task);

  void toggleTodo(Task task);

  void toggleImportant(Task task);

  void updateDescription(Task task);

  void updateCategory(Task task);

  void remove(Task task);
}
