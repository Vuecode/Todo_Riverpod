import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/local/local_database_service.dart';
import 'package:todo_app/data/repositories/todo_repository.dart';

/// Provider for TodoRepository
final todoRepositoryProvider = Provider((ref) {
  return TodoRepository(prefs: LocalDatabaseService.prefs);
});

/// Filter types for todos
enum TodoFilter {
  all('All'),
  completed('Completed'),
  pending('Pending'),
  high('High Priority'),
  medium('Medium Priority'),
  low('Low Priority');

  final String label;
  const TodoFilter(this.label);
}

/// Provider for current filter
final todoFilterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

/// Provider for search query
final todoSearchProvider = StateProvider<String>((ref) => '');

/// Provider for theme mode
final themeModeProvider = StateProvider<bool>((ref) => false); // false = light, true = dark
