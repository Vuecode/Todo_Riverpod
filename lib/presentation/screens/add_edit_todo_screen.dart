import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/core/utils/responsive_sizing.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/presentation/providers/todo_providers.dart';
import 'package:todo_app/presentation/widgets/common_widgets.dart'
    as common_widgets;

/// Add/Edit Todo Screen
class AddEditTodoScreen extends ConsumerStatefulWidget {
  final TodoModel? todoToEdit;

  const AddEditTodoScreen({
    this.todoToEdit,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends ConsumerState<AddEditTodoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedPriority;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    if (widget.todoToEdit != null) {
      _titleController = TextEditingController(text: widget.todoToEdit!.title);
      _descriptionController =
          TextEditingController(text: widget.todoToEdit!.description);
      _selectedPriority = widget.todoToEdit!.priority;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _selectedPriority = 'Medium';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.todoToEdit != null) {
          // Update existing todo
          final updatedTodo = widget.todoToEdit!.copyWith(
            title: _titleController.text,
            description: _descriptionController.text,
            priority: _selectedPriority,
          );
          await ref
              .read(todoNotifierProvider.notifier)
              .updateTodo(updatedTodo);
          common_widgets.AppSnackBar.showSuccess(
            context,
            'Task updated successfully',
          );
        } else {
          // Create new todo
          final newTodo = TodoModel(
            title: _titleController.text,
            description: _descriptionController.text,
            priority: _selectedPriority,
          );
          await ref.read(todoNotifierProvider.notifier).createTodo(newTodo);
          common_widgets.AppSnackBar.showSuccess(
            context,
            'Task created successfully',
          );
        }
        if (mounted) {
          context.pop();
        }
      } catch (e) {
        common_widgets.AppSnackBar.showError(
          context,
          'Failed to save todo: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todoToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create Task'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                Text(
                  'Task Title',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter task title',
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Title is required';
                    }
                    if (value!.length > 100) {
                      return 'Title must be less than 100 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.lg),

                // Description Field
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter task description',
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if ((value?.length ?? 0) > 500) {
                      return 'Description must be less than 500 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.lg),

                // Priority Selection
                Text(
                  'Priority',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.md,
                  children: ['Low', 'Medium', 'High']
                      .map((priority) => ChoiceChip(
                            label: Text(priority),
                            selected: _selectedPriority == priority,
                            onSelected: (selected) {
                              setState(() {
                                _selectedPriority = priority;
                              });
                            },
                          ))
                      .toList(),
                ),
                SizedBox(height: AppSpacing.xxl),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveTodo,
                        child: Text(
                          isEditing ? 'Update' : 'Create',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
