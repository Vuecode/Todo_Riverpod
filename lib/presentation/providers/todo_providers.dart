import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/presentation/providers/providers.dart';

/// Provider for fetching all todos
final allTodosProvider = FutureProvider<List<TodoModel>>((ref) async {
  final repository = ref.watch(todoRepositoryProvider);
  return repository.getAllTodos();
});

/// Provider for fetching filtered todos
final filteredTodosProvider = FutureProvider<List<TodoModel>>((ref) async {
  final repository = ref.watch(todoRepositoryProvider);
  final filter = ref.watch(todoFilterProvider);
  final search = ref.watch(todoSearchProvider);

  List<TodoModel> todos;

  switch (filter) {
    case TodoFilter.completed:
      todos = await repository.getCompletedTodos();
      break;
    case TodoFilter.pending:
      todos = await repository.getPendingTodos();
      break;
    case TodoFilter.high:
      todos = await repository.getTodosByPriority('High');
      break;
    case TodoFilter.medium:
      todos = await repository.getTodosByPriority('Medium');
      break;
    case TodoFilter.low:
      todos = await repository.getTodosByPriority('Low');
      break;
    case TodoFilter.all:
      todos = await repository.getAllTodos();
      break;
  }

  // Apply search filter
  if (search.isNotEmpty) {
    todos = todos
        .where((todo) =>
            todo.title.toLowerCase().contains(search.toLowerCase()) ||
            todo.description.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  // Sort by date (newest first)
  todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return todos;
});

/// Provider for dashboard statistics
final todoStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(todoRepositoryProvider);

  final total = await repository.getTotalsCount();
  final completed = await repository.getCompletedCount();
  final pending = await repository.getPendingCount();

  return {
    'total': total,
    'completed': completed,
    'pending': pending,
  };
});

/// Notifier for managing todo CRUD operations
class TodoNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  TodoNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> createTodo(TodoModel todo) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(todoRepositoryProvider);
      await repository.createTodo(todo);
      
      // Invalidate providers to refresh UI
      ref.invalidate(allTodosProvider);
      ref.invalidate(filteredTodosProvider);
      ref.invalidate(todoStatsProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(todoRepositoryProvider);
      await repository.updateTodo(todo);
      
      // Invalidate providers to refresh UI
      ref.invalidate(allTodosProvider);
      ref.invalidate(filteredTodosProvider);
      ref.invalidate(todoStatsProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTodo(int id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(todoRepositoryProvider);
      await repository.deleteTodo(id);
      
      // Invalidate providers to refresh UI
      ref.invalidate(allTodosProvider);
      ref.invalidate(filteredTodosProvider);
      ref.invalidate(todoStatsProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleTodoCompletion(TodoModel todo) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(todoRepositoryProvider);
      final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
      await repository.updateTodo(updatedTodo);
      
      // Invalidate providers to refresh UI
      ref.invalidate(allTodosProvider);
      ref.invalidate(filteredTodosProvider);
      ref.invalidate(todoStatsProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearAllTodos() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(todoRepositoryProvider);
      await repository.clearAll();
      
      // Invalidate providers to refresh UI
      ref.invalidate(allTodosProvider);
      ref.invalidate(filteredTodosProvider);
      ref.invalidate(todoStatsProvider);
      
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for todo operations notifier
final todoNotifierProvider = StateNotifierProvider<TodoNotifier, AsyncValue<void>>(
  (ref) => TodoNotifier(ref),
);
