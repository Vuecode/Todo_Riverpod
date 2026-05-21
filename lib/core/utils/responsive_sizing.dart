/// Responsive sizing utilities for different screen sizes
class AppSizing {
  // Device Size Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;
  static const double desktopBreakpoint = 1920;

  /// Get responsive padding based on screen width
  static double getResponsivePadding(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return 16.0;
    } else if (screenWidth < tabletBreakpoint) {
      return 24.0;
    }
    return 32.0;
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    double screenWidth, {
    required double mobileSize,
    required double tabletSize,
    required double desktopSize,
  }) {
    if (screenWidth < mobileBreakpoint) {
      return mobileSize;
    } else if (screenWidth < tabletBreakpoint) {
      return tabletSize;
    }
    return desktopSize;
  }

  /// Get responsive width
  static double getResponsiveWidth(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return screenWidth;
    } else if (screenWidth < tabletBreakpoint) {
      return screenWidth * 0.8;
    }
    return screenWidth * 0.6;
  }

  /// Check if device is mobile
  static bool isMobile(double screenWidth) => screenWidth < mobileBreakpoint;

  /// Check if device is tablet
  static bool isTablet(double screenWidth) =>
      screenWidth >= mobileBreakpoint && screenWidth < tabletBreakpoint;

  /// Check if device is desktop
  static bool isDesktop(double screenWidth) => screenWidth >= tabletBreakpoint;
}

/// Standard spacing values
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Standard border radius values
class AppRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double circle = 100.0;
}
