import 'package:amorin/dtos/create_todo.dto.dart';

abstract class TodoRepository {
  Future<void> createTodo(CreateTodoDto todo);
  Future<List<Map<String, dynamic>>> getTodos();
  Future<void> deleteTodo(String todoId);
  Future<void> updateTodo(String todoId, Map<String, dynamic> updates);
}

class TodoService {
  final TodoRepository repository;
  TodoService(this.repository);

  Future<void> createTodo(CreateTodoDto todo) {
    return repository.createTodo(todo);
  }

  Future<List<Map<String, dynamic>>> getTodos() {
    return repository.getTodos();
  }

  Future<void> deleteTodo(String todoId) {
    return repository.deleteTodo(todoId);
  }

  Future<void> updateTodo(String todoId, Map<String, dynamic> updates) {
    return repository.updateTodo(todoId, updates);
  }
}
