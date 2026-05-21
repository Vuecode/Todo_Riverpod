import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/local/local_database_service.dart';
import 'package:todo_app/data/models/todo_model.dart';

/// Repository for Todo CRUD operations
/// Supports SharedPreferences (web-compatible)
class TodoRepository {
  final SharedPreferences? _prefs;

  TodoRepository({SharedPreferences? prefs})
      : _prefs = prefs ?? LocalDatabaseService.prefs;

  static const String _todosKey = 'todos';

  /// Get all todos
  Future<List<TodoModel>> getAllTodos() async {
    try {
      return _getFromPrefs();
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  /// Get todo by ID
  Future<TodoModel?> getTodoById(int id) async {
    try {
      final todos = _getFromPrefs();
      try {
        return todos.firstWhere((t) => t.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch todo: $e');
    }
  }

  /// Create a new todo
  Future<int> createTodo(TodoModel todo) async {
    try {
      final todos = _getFromPrefs();
      final newId = todos.isEmpty ? 1 : (todos.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      todo.id = newId;
      todos.add(todo);
      await _saveToPrefs(todos);
      return newId;
    } catch (e) {
      throw Exception('Failed to create todo: $e');
    }
  }

  /// Update a todo
  Future<bool> updateTodo(TodoModel todo) async {
    try {
      final todos = _getFromPrefs();
      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index >= 0) {
        todos[index] = todo;
        await _saveToPrefs(todos);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  /// Delete a todo
  Future<bool> deleteTodo(int id) async {
    try {
      final todos = _getFromPrefs();
      todos.removeWhere((t) => t.id == id);
      await _saveToPrefs(todos);
      return true;
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }

  /// Search todos by title
  Future<List<TodoModel>> searchTodosByTitle(String query) async {
    try {
      final todos = await getAllTodos();
      return todos
          .where((todo) =>
              todo.title.toLowerCase().contains(query.toLowerCase()) ||
              todo.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search todos: $e');
    }
  }

  /// Get todos by priority
  Future<List<TodoModel>> getTodosByPriority(String priority) async {
    try {
      final todos = await getAllTodos();
      return todos.where((t) => t.priority == priority).toList();
    } catch (e) {
      throw Exception('Failed to fetch todos by priority: $e');
    }
  }

  /// Get completed todos
  Future<List<TodoModel>> getCompletedTodos() async {
    try {
      final todos = await getAllTodos();
      return todos.where((t) => t.isCompleted).toList();
    } catch (e) {
      throw Exception('Failed to fetch completed todos: $e');
    }
  }

  /// Get pending todos
  Future<List<TodoModel>> getPendingTodos() async {
    try {
      final todos = await getAllTodos();
      return todos.where((t) => !t.isCompleted).toList();
    } catch (e) {
      throw Exception('Failed to fetch pending todos: $e');
    }
  }

  /// Get total todos count
  Future<int> getTotalsCount() async {
    try {
      final todos = await getAllTodos();
      return todos.length;
    } catch (e) {
      throw Exception('Failed to get todos count: $e');
    }
  }

  /// Get completed todos count
  Future<int> getCompletedCount() async {
    try {
      final todos = await getCompletedTodos();
      return todos.length;
    } catch (e) {
      throw Exception('Failed to get completed count: $e');
    }
  }

  /// Get pending todos count
  Future<int> getPendingCount() async {
    try {
      final todos = await getPendingTodos();
      return todos.length;
    } catch (e) {
      throw Exception('Failed to get pending count: $e');
    }
  }

  /// Clear all todos
  Future<void> clearAll() async {
    try {
      await _prefs?.remove(_todosKey);
    } catch (e) {
      throw Exception('Failed to clear todos: $e');
    }
  }

  /// Helper: Get todos from SharedPreferences
  List<TodoModel> _getFromPrefs() {
    final jsonString = _prefs?.getString(_todosKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) {
        final map = item as Map<String, dynamic>;
        final todo = TodoModel(
          title: map['title'] ?? '',
          description: map['description'] ?? '',
          priority: map['priority'] ?? 'Medium',
          initialCreatedAt: map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : null,
        );
        todo.id = map['id'] as int?;
        todo.isCompleted = map['isCompleted'] ?? false;
        if (map['updatedAt'] != null) {
          todo.updatedAt = DateTime.parse(map['updatedAt']);
        }
        return todo;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Helper: Save todos to SharedPreferences
  Future<void> _saveToPrefs(List<TodoModel> todos) async {
    final jsonList = todos.map((t) {
      return {
        'id': t.id,
        'title': t.title,
        'description': t.description,
        'priority': t.priority,
        'isCompleted': t.isCompleted,
        'createdAt': t.createdAt.toIso8601String(),
        'updatedAt': t.updatedAt?.toIso8601String(),
      };
    }).toList();

    await _prefs?.setString(_todosKey, jsonEncode(jsonList));
  }
}
