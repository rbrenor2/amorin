import 'package:flutter/material.dart';
import 'package:amorin/services/todo.service.dart';
import 'package:amorin/dtos/create_todo.dto.dart';
import 'package:amorin/repositories/firebase.repository.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  final List<Map<String, dynamic>> todos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      final todoService = TodoService(FirebaseRepository());
      final loadedTodos = await todoService.getTodos();
      setState(() {
        todos.clear();
        todos.addAll(loadedTodos);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load todos: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedAndForMe = todos
        .where((todo) => todo['completed'] == true && todo['forMe'] == true)
        .length;
    final totalCompleted = todos
        .where((todo) => todo['completed'] == true)
        .length;
    final percentage = totalCompleted > 0
        ? (completedAndForMe / totalCompleted * 100).toStringAsFixed(0)
        : '0';

    return Column(
      children: [
        if (todos.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'done for myself',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : todos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.checklist,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      const Text("No todo's added yet."),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return CheckboxListTile(
                      value: todo['completed'] ?? false,
                      onChanged: (value) async {
                        final todoId = todo['id'];
                        if (todoId != null) {
                          try {
                            final todoService = TodoService(
                              FirebaseRepository(),
                            );
                            await todoService.updateTodo(todoId, {
                              'completed': value ?? false,
                            });
                            setState(() {
                              todos[index]['completed'] = value ?? false;
                            });
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update todo: $e'),
                                ),
                              );
                            }
                          }
                        }
                      },
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        todo['name'],
                        style: TextStyle(
                          decoration: todo['completed'] == true
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      secondary: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final todoId = todo['id'];
                          if (todoId != null) {
                            try {
                              final todoService = TodoService(
                                FirebaseRepository(),
                              );
                              await todoService.deleteTodo(todoId);
                              setState(() {
                                todos.removeAt(index);
                              });
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete todo: $e'),
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () => _showAddDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  dynamic onAdd() {}

  Future<void> _showAddDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    bool forMe = false;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New Todo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter todo name',
                      labelText: 'Name',
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: forMe,
                        onChanged: (value) {
                          setDialogState(() {
                            forMe = value ?? false;
                          });
                        },
                      ),
                      const Text("I'm doing it for myself"),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    final todoName = controller.text;
                    if (todoName.isNotEmpty) {
                      try {
                        // Create and save todo to Firebase
                        final todoDto = CreateTodoDto(
                          title: todoName,
                          forMe: forMe,
                        );
                        final todoService = TodoService(FirebaseRepository());
                        await todoService.createTodo(todoDto);

                        // Add to local state
                        setState(() {
                          todos.add({
                            'name': todoName,
                            'forMe': forMe,
                            'completed': false,
                          });
                        });
                        Navigator.of(context).pop();
                      } catch (e) {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add todo: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
