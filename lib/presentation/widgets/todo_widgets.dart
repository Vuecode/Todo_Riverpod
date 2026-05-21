import 'package:flutter/material.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/core/utils/extensions.dart';
import 'package:todo_app/core/utils/responsive_sizing.dart';
import 'package:todo_app/data/models/todo_model.dart';

/// Todo card widget for displaying a single todo
class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(bool?)? onCompletionChanged;

  const TodoCard({
    required this.todo,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.onCompletionChanged,
    Key? key,
  }) : super(key: key);

  Color _getPriorityColor() {
    switch (todo.priority.toLowerCase()) {
      case 'high':
        return AppColors.highPriority;
      case 'medium':
        return AppColors.mediumPriority;
      case 'low':
        return AppColors.lowPriority;
      default:
        return AppColors.gray400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with checkbox and title
              Row(
                children: [
                  Checkbox(
                    value: todo.isCompleted,
                    onChanged: onCompletionChanged,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),

              // Description
              if (todo.description.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 56.0, bottom: AppSpacing.md),
                  child: Text(
                    todo.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Footer with priority and date
              Padding(
                padding: EdgeInsets.only(left: 56.0),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        todo.priority,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getPriorityColor(),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      todo.createdAt.toFormattedDate(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Todo list view widget
class TodoListView extends StatelessWidget {
  final List<TodoModel> todos;
  final VoidCallback onTodoTap;
  final Function(TodoModel) onEdit;
  final Function(TodoModel) onDelete;
  final Function(TodoModel) onCompletionChanged;

  const TodoListView({
    required this.todos,
    required this.onTodoTap,
    required this.onEdit,
    required this.onDelete,
    required this.onCompletionChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoCard(
          todo: todo,
          onTap: onTodoTap,
          onEdit: () => onEdit(todo),
          onDelete: () => onDelete(todo),
          onCompletionChanged: (_) => onCompletionChanged(todo),
        );
      },
    );
  }
}

/// Todo grid view widget
class TodoGridView extends StatelessWidget {
  final List<TodoModel> todos;
  final VoidCallback onTodoTap;
  final Function(TodoModel) onEdit;
  final Function(TodoModel) onDelete;
  final Function(TodoModel) onCompletionChanged;

  const TodoGridView({
    required this.todos,
    required this.onTodoTap,
    required this.onEdit,
    required this.onDelete,
    required this.onCompletionChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppSizing.isMobile(MediaQuery.of(context).size.width)
            ? 1
            : AppSizing.isTablet(MediaQuery.of(context).size.width)
                ? 2
                : 3,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.2,
      ),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoCard(
          todo: todo,
          onTap: onTodoTap,
          onEdit: () => onEdit(todo),
          onDelete: () => onDelete(todo),
          onCompletionChanged: (_) => onCompletionChanged(todo),
        );
      },
    );
  }
}
