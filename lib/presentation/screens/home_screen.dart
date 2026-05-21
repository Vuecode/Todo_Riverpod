import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/core/utils/responsive_sizing.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/presentation/providers/providers.dart';
import 'package:todo_app/presentation/providers/todo_providers.dart';
import 'package:todo_app/presentation/widgets/common_widgets.dart'
    as common_widgets;
import 'package:todo_app/presentation/widgets/todo_widgets.dart';

/// Home Dashboard Screen
class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final filter = ref.watch(todoFilterProvider);
    final stats = ref.watch(todoStatsProvider);
    final filteredTodos = ref.watch(filteredTodosProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = AppSizing.isMobile(screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state = !isDarkMode;
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Stats
              stats.when(
                data: (data) => _buildStatsCards(context, data),
                loading: () => const common_widgets.LoadingIndicator(),
                error: (error, stack) => common_widgets.ErrorWidget(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(todoStatsProvider),
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // Filters
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: AppSpacing.md),
              _buildFilterChips(context, ref, filter),

              SizedBox(height: AppSpacing.xl),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search todos...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
                onChanged: (value) {
                  ref.read(todoSearchProvider.notifier).state = value;
                },
              ),

              SizedBox(height: AppSpacing.xl),

              // Todos List
              Text(
                'Tasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: AppSpacing.md),
              filteredTodos.when(
                data: (todos) {
                  if (todos.isEmpty) {
                    return common_widgets.EmptyStateWidget(
                      title: 'No tasks found',
                      message: 'Create your first todo to get started!',
                      icon: Icons.task_alt,
                      onAction: () => context.push('/add-todo'),
                      actionLabel: 'Create Todo',
                    );
                  }

                  return TodoListView(
                    todos: todos,
                    onTodoTap: () {},
                    onEdit: (todo) {
                      context.push('/edit-todo/${todo.id}', extra: todo);
                    },
                    onDelete: (todo) {
                      _showDeleteConfirmation(context, ref, todo);
                    },
                    onCompletionChanged: (todo) {
                      ref
                          .read(todoNotifierProvider.notifier)
                          .toggleTodoCompletion(todo);
                    },
                  );
                },
                loading: () => const common_widgets.LoadingIndicator(),
                error: (error, stack) => common_widgets.ErrorWidget(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(filteredTodosProvider),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-todo'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, Map<String, int> stats) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _StatCard(
            title: 'Total Tasks',
            value: stats['total'].toString(),
            icon: Icons.task_alt,
            color: AppColors.primary,
          ),
          SizedBox(width: AppSpacing.md),
          _StatCard(
            title: 'Completed',
            value: stats['completed'].toString(),
            icon: Icons.check_circle,
            color: AppColors.success,
          ),
          SizedBox(width: AppSpacing.md),
          _StatCard(
            title: 'Pending',
            value: stats['pending'].toString(),
            icon: Icons.hourglass_empty,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref, TodoFilter filter) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: TodoFilter.values.map((f) {
        return FilterChip(
          label: Text(f.label),
          selected: filter == f,
          onSelected: (_) {
            ref.read(todoFilterProvider.notifier).state = f;
          },
        );
      }).toList(),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, TodoModel todo) {
    showDialog(
      context: context,
      builder: (context) => common_widgets.ConfirmationDialog(
        title: 'Delete Task',
        message: 'Are you sure you want to delete "${todo.title}"?',
        confirmLabel: 'Delete',
        cancelLabel: 'Cancel',
        isDangerous: true,
        onConfirm: () {
          if (todo.id != null) {
            ref.read(todoNotifierProvider.notifier).deleteTodo(todo.id!);
          }
          common_widgets.AppSnackBar.showSuccess(context, 'Task deleted');
        },
      ),
    );
  }
}

/// Statistics card widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
