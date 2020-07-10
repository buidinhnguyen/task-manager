import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/repositories/todo_repository_interface.dart';

class TodoRepository implements ITodoRepository {
  Firestore firestore;

  @override
  Stream<List<Task>> getTodos() {
    this.firestore = Firestore.instance;
    return this.firestore.collection('task').snapshots().map((query) {
      return query.documents.map((doc) {
        return fromDocument(doc);
      }).toList();
    });
  }

  Future<DocumentReference> addTodo(Task task) {
    this.firestore = Firestore.instance;
    return this.firestore.collection('task').add(task.toJson());
  }

  Task fromDocument(DocumentSnapshot doc) {
    return Task(
        name: doc['name'],
        description: doc['description'],
        done: doc['done'],
        id: doc.reference);
  }
}
