import 'package:amorin/dtos/create_todo.dto.dart';

abstract class TodoRepository {
  Future<void> createTodo(CreateTodoDto todo);
}

class TodoService {
  final TodoRepository repository;
  TodoService(this.repository);

  Future<void> createTodo(CreateTodoDto todo) {
    return repository.createTodo(todo);
  }
}
