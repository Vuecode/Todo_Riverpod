import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/constants/app_constants.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/core/utils/responsive_sizing.dart';

/// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(
      const Duration(
        milliseconds: AppConstants.splashDuration,
      ),
      () {
        if (mounted) {
          context.go('/home');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.checklist_rtl,
                  size: 60,
                  color: AppColors.primary,
                ),
              )
                  .animate()
                  .scale(
                    duration: const Duration(milliseconds: 600),
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                  )
                  .then()
                  .shake(
                    duration: const Duration(milliseconds: 200),
                  ),
              SizedBox(height: AppSpacing.xxl),

              // App Name
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
              )
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 800)),

              SizedBox(height: AppSpacing.md),

              // Tagline
              Text(
                'Organize Your Life',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white.withOpacity(0.8),
                    ),
              )
                  .animate()
                  .fadeIn(
                    duration: const Duration(milliseconds: 1000),
                  )
                  .slideY(begin: 0.5, end: 0),

              SizedBox(height: AppSpacing.xxl),

              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.white.withOpacity(0.8),
                  ),
                  strokeWidth: 2,
                ),
              )
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 1200)),
            ],
          ),
        ),
      ),
    );
  }
}
