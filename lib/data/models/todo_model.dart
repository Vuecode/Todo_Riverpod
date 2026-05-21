import 'package:isar/isar.dart';

part 'todo_model.g.dart';

/// Todo Priority Enum
enum TodoPriority {
  low('Low'),
  medium('Medium'),
  high('High');

  final String label;
  const TodoPriority(this.label);

  /// Convert string to TodoPriority
  static TodoPriority fromString(String value) {
    return TodoPriority.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TodoPriority.medium,
    );
  }
}

/// Todo Model
class TodoModel {
  Id? id;

  late String title;

  late String description;

  late String priority;

  late bool isCompleted;

  late DateTime createdAt;

  DateTime? updatedAt;

  /// Constructor
  TodoModel({
    required this.title,
    required this.description,
    this.priority = 'Medium',
    this.isCompleted = false,
    DateTime? initialCreatedAt,
    this.updatedAt,
  }) {
    createdAt = initialCreatedAt ?? DateTime.now();
  }

  /// Create a copy with modifications
  TodoModel copyWith({
    String? title,
    String? description,
    String? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoModel(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      initialCreatedAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    )..id = id;
  }

  /// Convert to JSON for debugging/serialization
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() => 'TodoModel(id: $id, title: $title, priority: $priority)';
}
