import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/presentation/screens/add_edit_todo_screen.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';
import 'package:todo_app/presentation/screens/settings_screen.dart';
import 'package:todo_app/presentation/screens/splash_screen.dart';

/// Root navigator key for managing dialogs and overlays
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// App Router Configuration
final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Splash Screen
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // Home Screen
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        // Add Todo
        GoRoute(
          path: 'add-todo',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const AddEditTodoScreen(),
        ),

        // Edit Todo
        GoRoute(
          path: 'edit-todo/:id',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final todoToEdit = state.extra as TodoModel?;
            return AddEditTodoScreen(todoToEdit: todoToEdit);
          },
        ),

        // Settings
        GoRoute(
          path: 'settings',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),

    // Add Todo (from root)
    GoRoute(
      path: '/add-todo',
      builder: (context, state) => const AddEditTodoScreen(),
    ),

    // Edit Todo (from root)
    GoRoute(
      path: '/edit-todo/:id',
      builder: (context, state) {
        final todoToEdit = state.extra as TodoModel?;
        return AddEditTodoScreen(todoToEdit: todoToEdit);
      },
    ),

    // Settings (from root)
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);