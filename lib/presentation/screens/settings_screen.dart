import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/core/constants/app_constants.dart';
import 'package:todo_app/core/utils/responsive_sizing.dart';
import 'package:todo_app/presentation/providers/providers.dart';
import 'package:todo_app/presentation/providers/todo_providers.dart';
import 'package:todo_app/presentation/widgets/common_widgets.dart'
    as common_widgets;

/// Settings Screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Section
              _SettingSection(
                title: 'Appearance',
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      isDarkMode
                          ? 'Dark theme is enabled'
                          : 'Light theme is enabled',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        ref.read(themeModeProvider.notifier).state = value;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.xl),

              // Data Management Section
              _SettingSection(
                title: 'Data Management',
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Clear All Tasks',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Delete all tasks permanently',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.delete),
                    onTap: () {
                      _showClearAllConfirmation(context, ref);
                    },
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.xl),

              // About Section
              _SettingSection(
                title: 'About',
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'App Name',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Divider(height: AppSpacing.lg),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Version',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      AppConstants.appVersion,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.xl),

              // Footer
              Center(
                child: Text(
                  'Built with Flutter & Riverpod',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearAllConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => common_widgets.ConfirmationDialog(
        title: 'Clear All Tasks',
        message:
            'Are you sure you want to delete all tasks? This action cannot be undone.',
        confirmLabel: 'Delete All',
        cancelLabel: 'Cancel',
        isDangerous: true,
        onConfirm: () {
          ref.read(todoNotifierProvider.notifier).clearAllTodos();
          common_widgets.AppSnackBar.showSuccess(
            context,
            'All tasks deleted',
          );
        },
      ),
    );
  }
}

/// Settings section widget
class _SettingSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingSection({
    required this.title,
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
