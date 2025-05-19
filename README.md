# StudyBuddy 📚✨

A **gamified learning platform** built with Flutter and Firebase. StuddyBuddy turns studying into an engaging adventure: unlock lessons, earn stars and coins, adopt virtual pets, compete on the global leaderboard, and keep your daily study streak alive!

## 1. System Description

StudyBuddy is a mobile app that helps learners stay motivated through:

| Module | Description |
| -------| -----------|
| **Courses & Lessons** | Modular lesson screens, progress tracking, rich-text content. |
| **Quizzes** | Auto-graded multiple-choice quizzes with extra-life retries. |
| **Rewards & Economy** | Stars and coins for correct answers; in-app shop for avatar frames, pets, boosts. |
| **User Profiles** | Custom avatars, daily/longest study streaks, inventory management. |
| **Leaderboard** | Real-time global ranking driven by Firebase Cloud Firestore. |

All data (users, progress, shop inventory, quiz attempts) lives in **Firebase** so your learning journey is synced across devices.

## 2. Technologies & Packages

| Category | Package | Purpose |
|----------|-----------------|---------|
| **Framework** | 3.29.2 | Cross-platform UI |
| **Backend** | Firebase Core, Auth, Cloud Firestore | Authentication, data, images |
| **UI Widgets** | `cupertino_icons`, `auto_size_text`, `flutter_carousel_widget`, `lottie` | Polished UI/animation |
| **Storage** | `image_picker`, `path_provider`, `shared_preferences` | Gallery access & local caching |
| **Validation** | `email_validator` | Form validation |
| **Testing** | `firebase_auth_mocks`, `fake_cloud_firestore`, `flutter_test` | Unit / widget tests |

## 3. Full Dependency List

### Dependencies in pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^3.12.1
  firebase_auth: ^5.4.2
  cloud_firestore: ^5.6.6
  firebase_storage: ^12.4.5
  image_picker: ^1.1.2
  shared_preferences: ^2.5.1
  path_provider: ^2.1.5
  lottie: ^3.2.0
  auto_size_text: ^3.0.0
  flutter_carousel_widget: ^3.1.0
  email_validator: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  firebase_auth_mocks: ^0.14.1
  fake_cloud_firestore: ^3.1.0
```

## 4. Installation & Running

### 4.1 Prerequisites
* Flutter SDK ≥ 3.29.2  
* Dart (ships with Flutter)  
* Android Studio or VS Code with Flutter & Dart plugins  
* A Firebase project (Free Spark plan is sufficient)

### 4.2 Clone & Install
```bash
git clone https://github.com/Yang-703/CS49900-.git
cd StudyBuddy
flutter pub get
```

### 4.3 Configure Firebase

1. In the [Firebase Console](https://console.firebase.google.com/), create a project and add an Android and/or iOS app.

2. Download the configuration files:
    - **Android**: `google-services.json` → place in `android/app/`
    - **iOS**: `GoogleService-Info.plist` → place in `ios/Runner/`

3. *(Optional)* Enable **Email/Password** authentication under the **Authentication** section.

4. In **Cloud Firestore**, create or allow the app to create the following collections:
    - `users`
    - `questions`

**Important:** The default `DefaultFirebaseOptions.currentPlatform` in `lib/main.dart` expects the generated `firebase_options.dart`. Run `flutterfire configure` or `dart run build_runner build` as described in the FlutterFire CLI documentation.

### 4.4 Run the App

#### For Android/iOS Emulator or Connected Device
```bash
flutter run
```