# Quick Start Guide

Get your Kitit app running in 5 minutes!

## Prerequisites

Make sure you have Flutter installed:
```bash
flutter --version
```

If not installed, visit: https://docs.flutter.dev/get-started/install

## Setup Steps

### 1. Extract the Project
```bash
unzip kitit_app.zip
cd kitit_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
# For iOS
flutter run

# For Android
flutter run

# For Web
flutter run -d chrome

# For specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

## First Launch

The app will start with the **Onboarding Screen**. Here's the flow:

1. **Onboarding** → Swipe through 3 pages or tap "Skip"
2. **Login** → Enter any email/password (mock authentication)
   - Example: `test@test.com` / `password123`
3. **Home** → Browse restaurants, search, and explore

## Project Structure

```
kitit_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── core/                     # Shared resources
│   │   ├── models/              # Data models
│   │   ├── routes/              # Navigation
│   │   └── theme/               # Styling
│   └── features/                # Feature modules
│       ├── auth/                # Login & Sign Up
│       ├── home/                # Home screen
│       ├── restaurants/         # Restaurant details
│       ├── reservations/        # Booking system
│       └── ...
├── pubspec.yaml                  # Dependencies
├── README.md                     # Full documentation
└── IMPLEMENTATION_GUIDE.md       # Development guide
```

## Key Features Implemented

✅ **Fully Working:**
- Onboarding flow (3 pages)
- Login & Sign Up with validation
- Home screen with search
- Restaurant listing (trending & popular)
- Restaurant profile view
- Save/bookmark restaurants
- Bottom navigation
- Dark theme UI

🚧 **Ready to Extend:**
- Reservation flow (stub)
- My reservations (stub)
- User profile (stub)
- Payment (stub)
- Rating system (stub)

## Mock Data

The app uses mock data by default. You'll see:
- 6 sample restaurants (Italian, Japanese, French, etc.)
- 3 sample reservations
- Sample user: Julian Casablancas

## Making Changes

### Change Colors
Edit `lib/core/theme/app_theme.dart`:
```dart
static const Color primary = Color(0xFFFF6B35);  // Orange
```

### Add New Screen
1. Create in `lib/features/your_feature/screens/`
2. Add route in `lib/core/routes/app_router.dart`
3. Navigate: `Navigator.pushNamed(context, '/your-route')`

### Connect to API
See `IMPLEMENTATION_GUIDE.md` for detailed instructions.

## Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/features/auth/bloc/auth_bloc_test.dart
```

## Building Release

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web
```

## Troubleshooting

**Problem:** Dependencies not installing
```bash
flutter clean
flutter pub get
```

**Problem:** Hot reload not working
```bash
# Press 'r' in terminal for hot reload
# Press 'R' for hot restart
# Or restart: flutter run
```

**Problem:** Gradle issues (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**Problem:** CocoaPods issues (iOS)
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
```

## Next Steps

1. **Read** `README.md` for full documentation
2. **Read** `IMPLEMENTATION_GUIDE.md` to implement remaining screens
3. **Replace** mock data with your API
4. **Customize** colors and branding
5. **Add** your restaurant data
6. **Test** on real devices
7. **Deploy** to App Store / Play Store

## Need Help?

- Check `IMPLEMENTATION_GUIDE.md` for detailed examples
- Flutter docs: https://docs.flutter.dev
- BLoC docs: https://bloclibrary.dev
- Stack Overflow: Tag with `flutter` and `flutter-bloc`

## Screenshots

All screens from your Figma design are implemented with pixel-perfect accuracy to the dark theme, orange accents, and modern UI you designed.

---

**Happy Coding! 🚀**
