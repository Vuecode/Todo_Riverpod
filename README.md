# Todo App - Flutter 3.19.2

A modern, responsive, production-ready Todo CRUD application built with Flutter using clean architecture, Riverpod for state management, and multi-platform support.

## 🎯 Project Overview

This is a complete Todo application that demonstrates best practices in Flutter development including:
- **Clean Architecture**: Separation of concerns with core, data, and presentation layers
- **State Management**: Riverpod for reactive state updates
- **Local Storage**: SharedPreferences for web/cross-platform compatibility
- **Responsive Design**: Adaptive layouts for mobile, tablet, web, and desktop
- **Modern UI**: Material 3 design with light and dark themes
- **Production Ready**: Null safety, error handling, and comprehensive feature set

## ✨ Features

### Core CRUD Operations
- ✅ **Create**: Add new todos with title, description, and priority
- ✅ **Read**: Display all todos with filtering and search
- ✅ **Update**: Edit existing todos and mark as complete/pending
- ✅ **Delete**: Remove todos with confirmation dialog

### Advanced Features
- 🔍 **Search**: Search todos by title or description
- 🏷️ **Filtering**: Filter by status (All, Completed, Pending) or priority (High, Medium, Low)
- 📊 **Statistics**: Dashboard with total, completed, and pending task counts
- 🎨 **Theme**: Light and dark mode toggle with persistent storage
- 📱 **Responsive**: Optimized layouts for mobile, tablet, web, and desktop
- ⚡ **Smooth Animations**: Animated transitions and UI elements
- 💾 **Data Persistence**: Todos persist after app restart/browser refresh

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart        # App configuration
│   ├── theme/
│   │   └── app_theme.dart            # Material 3 themes
│   └── utils/
│       ├── extensions.dart           # Utility extensions
│       └── responsive_sizing.dart    # Responsive utilities
│
├── data/
│   ├── models/
│   │   └── todo_model.dart           # Todo model
│   ├── local/
│   │   └── local_database_service.dart # Storage service
│   └── repositories/
│       └── todo_repository.dart      # CRUD operations
│
├── presentation/
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── add_edit_todo_screen.dart
│   │   └── settings_screen.dart
│   ├── widgets/
│   │   ├── common_widgets.dart
│   │   └── todo_widgets.dart
│   └── providers/
│       ├── providers.dart
│       └── todo_providers.dart
│
├── routes/
│   └── app_router.dart
│
└── main.dart
```

## 🛠️ Technology Stack

- **Flutter**: 3.19.2
- **Dart**: 3.3.0
- **State Management**: flutter_riverpod
- **Local Storage**: shared_preferences
- **Routing**: go_router
- **Animations**: flutter_animate
- **UI**: Material 3, Google Fonts
- **Utilities**: intl, path_provider

## 🚀 Getting Started

### Prerequisites
- Flutter 3.19.2+
- Dart 3.3.0+

### Installation

```bash
# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on Android
flutter run -d android

# Build for web
flutter build web --profile
```

### Build Release

```bash
# Web release
flutter build web --release

# Android release
flutter build apk --release
```

## 📱 Screens

1. **Splash Screen**: Animated loading screen
2. **Home Dashboard**: Todo list with filters and search
3. **Add/Edit Todo**: Form to create/edit todos
4. **Settings**: Theme toggle and app settings

## 🎨 Features Highlights

- ✅ Complete CRUD operations
- ✅ Advanced filtering and search
- ✅ Responsive design (mobile, tablet, web, desktop)
- ✅ Light and dark themes
- ✅ Smooth animations
- ✅ Data persistence
- ✅ Error handling
- ✅ Form validation
- ✅ Confirmation dialogs
- ✅ Loading states

## 💾 Data Persistence

Uses SharedPreferences for universal compatibility. Data persists across:
- App restarts
- Browser refresh (web)
- Device reboot

## 📊 Responsive Breakpoints

- **Mobile**: < 600px
- **Tablet**: 600-1200px
- **Desktop**: > 1200px

## 📝 Code Quality

- ✅ 100% null-safe
- ✅ Flutter lint compliant
- ✅ Well-documented
- ✅ Error handling
- ✅ Input validation
- ✅ Performance optimized

## 🎬 Animations

- Splash screen animations
- Page transitions
- Task completion animations
- Dialog animations
- Smooth state updates

## 🐛 Error Handling

- Validation errors
- Storage errors
- User-friendly messages
- Loading states
- Confirmation dialogs

## 📄 License

MIT License - Feel free to use as a template for your projects!

---

**Built with Flutter 3.19.2** ❤️
