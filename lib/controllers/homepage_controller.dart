import 'package:mobx/mobx.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/repositories/todo_repository.dart';
import 'package:task_manager/repositories/todo_repository_interface.dart';
part 'homepage_controller.g.dart';

class HomePageController = _HomePageController with _$HomePageController;

abstract class _HomePageController with Store {
  ITodoRepository todoRepository = TodoRepository();

  @observable
  ObservableStream<List<Task>> todos;

  _HomePageController() {
    getTodos();
  }

  @action
  getTodos() {
    todos = todoRepository.getTodos().asObservable();
  }

  @action
  toggleTodo(Task task) {
    todoRepository.toggleTodo(task);
  }
}
