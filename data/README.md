# Kitit - Restaurant Discovery & Booking App

A modern Flutter application for discovering and booking restaurants, built with BLoC state management and following clean architecture principles.

## 🎨 Features

- **Onboarding Flow**: Beautiful introduction to the app
- **Authentication**: Login and Sign Up screens
- **Home Discovery**: Browse trending and popular restaurants
- **Restaurant Profiles**: Detailed information about restaurants
- **Reservation System**: Book tables at your favorite restaurants
- **Saved Places**: Bookmark restaurants for later
- **User Profile**: Manage your account and preferences
- **Explore & Filter**: Advanced search and filtering
- **Rating System**: Rate and review your experiences
- **Payment Integration**: Checkout for reservations

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **BLoC Pattern** for state management:

```
lib/
├── core/
│   ├── models/          # Data models (Restaurant, User, Reservation)
│   ├── routes/          # App navigation and routing
│   └── theme/           # App theme, colors, and styling
├── features/
│   ├── auth/            # Authentication (Login, Sign Up)
│   │   ├── bloc/
│   │   └── screens/
│   ├── home/            # Home screen with restaurant discovery
│   │   ├── screens/
│   │   └── widgets/
│   ├── restaurants/     # Restaurant details and profiles
│   │   ├── bloc/
│   │   └── screens/
│   ├── reservations/    # Booking and reservation management
│   │   ├── bloc/
│   │   └── screens/
│   ├── saved_places/    # Saved/bookmarked restaurants
│   │   ├── bloc/
│   │   └── screens/
│   ├── profile/         # User profile management
│   ├── explore/         # Advanced search and filters
│   ├── rating/          # Rating and review system
│   └── payment/         # Payment and checkout
└── main.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: >=3.0.0
- Dart SDK: >=3.0.0
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd kitit_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🔥 Firebase Backend

This app uses **Firebase** as the backend:

- **Firebase Authentication** - User sign up and login
- **Cloud Firestore** - NoSQL database for restaurants, reservations, and user data
- **Firebase Storage** - Image storage for profile pictures and restaurant images

### Quick Firebase Setup

1. Create a Firebase project at [firebase.google.com](https://firebase.google.com)
2. Follow the detailed setup guide in `FIREBASE_SETUP.md`
3. Add your Firebase config files:
   - Android: `google-services.json`
   - iOS: `GoogleService-Info.plist`
   - Web: `firebase-config.js`
4. Run the app!

See `FIREBASE_SETUP.md` for complete instructions.

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3       # State management
  equatable: ^2.0.5          # Value equality for BLoC states/events
  firebase_core: ^2.24.2     # Firebase core
  firebase_auth: ^4.16.0     # Firebase authentication
  cloud_firestore: ^4.14.0   # Cloud Firestore database
  firebase_storage: ^11.6.0  # Firebase storage
  intl: ^0.18.1              # Date formatting
```

## 🎨 Design System

### Color Palette

- **Primary**: `#FF6B35` (Orange)
- **Background**: `#1A1A1A` (Dark)
- **Surface**: `#2A2A2A`
- **Text Primary**: `#FFFFFF`
- **Text Secondary**: `#B0B0B0`

### Typography

The app uses a clean, modern sans-serif font with multiple weights for hierarchy.

## 🔥 Key Screens

### 1. Onboarding
- **Path**: `features/onboarding/screens/onboarding_screen.dart`
- **Description**: 3-page swipeable introduction to the app
- **Features**: Page indicators, skip button, smooth transitions

### 2. Authentication
- **Login**: `features/auth/screens/login_screen.dart`
- **Sign Up**: `features/auth/screens/signup_screen.dart`
- **Features**: Form validation, BLoC state management, social login options

### 3. Home
- **Path**: `features/home/screens/home_screen.dart`
- **Features**: 
  - Search with real-time filtering
  - Category chips
  - Trending restaurants carousel
  - Popular searches list
  - Bottom navigation
  - Restaurant cards with save functionality

### 4. Restaurant Profile
- **Path**: `features/restaurants/screens/restaurant_profile_screen.dart`
- **Features**:
  - Hero image
  - Rating and reviews
  - Restaurant information
  - About section
  - Book button (navigates to reservation flow)

### 5. Reservations
- **Reservation Flow**: `features/reservations/screens/reservation_flow_screen.dart`
- **My Reservations**: `features/reservations/screens/my_reservations_screen.dart`
- **Features**: Date/time selection, guest count, special requests

## 🧩 BLoC Structure

### AuthBloc
**Events:**
- `LoginRequested`
- `SignUpRequested`
- `LogoutRequested`
- `CheckAuthStatus`

**States:**
- `AuthInitial`
- `AuthLoading`
- `AuthAuthenticated`
- `AuthUnauthenticated`
- `AuthError`

### RestaurantBloc
**Events:**
- `LoadRestaurants`
- `SearchRestaurants`
- `FilterRestaurants`
- `LoadRestaurantDetails`

**States:**
- `RestaurantInitial`
- `RestaurantLoading`
- `RestaurantLoaded`
- `RestaurantDetailsLoaded`
- `RestaurantError`

### ReservationBloc
**Events:**
- `LoadReservations`
- `CreateReservation`
- `CancelReservation`
- `UpdateReservation`

**States:**
- `ReservationInitial`
- `ReservationLoading`
- `ReservationLoaded`
- `ReservationCreated`
- `ReservationError`

### SavedPlacesBloc
**Events:**
- `LoadSavedPlaces`
- `ToggleSavedPlace`
- `RemoveSavedPlace`

**States:**
- `SavedPlacesInitial`
- `SavedPlacesLoading`
- `SavedPlacesLoaded`
- `SavedPlacesError`

## 🎯 Navigation Routes

All routes are defined in `core/routes/app_router.dart`:

- `/` - Onboarding
- `/login` - Login screen
- `/signup` - Sign Up screen
- `/home` - Home screen (main app)
- `/restaurant-profile` - Restaurant details
- `/reservation-flow` - Book a table
- `/my-reservations` - View reservations
- `/saved-places` - Saved restaurants
- `/user-profile` - User profile
- `/explore` - Explore and filter
- `/rate-experience` - Rate a restaurant
- `/payment` - Payment checkout

## 🔧 Mock Data

The app currently uses mock data for demonstration purposes. Mock data is generated in the BLoCs:

- **Restaurants**: 6 sample restaurants with different cuisines
- **Reservations**: 3 sample reservations (upcoming and past)
- **Reviews**: Sample user reviews

## 🚧 Extending the App

### Adding a New Feature

1. **Create feature folder** in `lib/features/`
2. **Add BLoC** (if state management needed):
   - Create `bloc/` folder
   - Add `feature_event.dart`
   - Add `feature_state.dart`
   - Add `feature_bloc.dart`
3. **Create screens** in `screens/` folder
4. **Add route** in `app_router.dart`
5. **Register BLoC** in `main.dart` if needed

### Connecting to a Real Backend

Replace mock data in BLoCs with API calls:

```dart
// Example in RestaurantBloc
Future<void> _onLoadRestaurants(
  LoadRestaurants event,
  Emitter<RestaurantState> emit,
) async {
  emit(RestaurantLoading());
  
  try {
    // Replace this with your API call
    final response = await http.get('your-api-endpoint/restaurants');
    final restaurants = (response.data as List)
        .map((json) => Restaurant.fromJson(json))
        .toList();
    
    emit(RestaurantLoaded(restaurants: restaurants, ...));
  } catch (e) {
    emit(RestaurantError(e.toString()));
  }
}
```

### Adding Images

1. Create `assets/images/` folder in project root
2. Add images to the folder
3. Update `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/images/
   ```
4. Use in code:
   ```dart
   Image.asset('assets/images/your-image.png')
   ```

## 📱 Screens from Figma

The following screens from your Figma design are implemented:

✅ **Implemented:**
- Onboarding (3 pages)
- Login
- Sign Up
- Home/Discovery with search and categories
- Restaurant Profile with booking button
- Bottom Navigation

🚧 **Stub implementations (ready to extend):**
- Reservation Flow (date/time selection)
- My Reservations (upcoming/past)
- Saved Places
- User Profile
- Explore & Filter
- Rate Experience
- Payment Checkout

## 🎨 Customization

### Colors
Edit `lib/core/theme/app_theme.dart` to change the color scheme:

```dart
class AppColors {
  static const Color primary = Color(0xFFFF6B35); // Change this
  static const Color background = Color(0xFF1A1A1A); // And this
  // ... more colors
}
```

### Typography
Modify text styles in the same file under `textTheme`.

## 🐛 Troubleshooting

### Common Issues

**1. Dependencies not resolving:**
```bash
flutter pub get
flutter clean
flutter pub get
```

**2. BLoC not updating UI:**
- Ensure you're using `BlocBuilder` or `BlocListener`
- Check that events are being added to the BLoC
- Verify states are properly emitted

**3. Navigation errors:**
- Check route names match in `app_router.dart`
- Ensure all screens are properly registered

## 📝 Next Steps

1. **Add Real API Integration**
   - Create a repository layer
   - Add HTTP client (dio, http)
   - Implement API endpoints

2. **Add Authentication Persistence**
   - Use `shared_preferences` or `flutter_secure_storage`
   - Store user tokens
   - Implement auto-login

3. **Enhance UI**
   - Add animations (hero transitions, page transitions)
   - Implement loading skeletons
   - Add empty states

4. **Add More Features**
   - Push notifications
   - Deep linking
   - Analytics
   - Crash reporting

5. **Testing**
   - Unit tests for BLoCs
   - Widget tests for screens
   - Integration tests

## 📄 License

This project is a template/starter code for your restaurant booking app.

## 🤝 Contributing

Feel free to extend and modify this codebase for your needs!

---

**Built with ❤️ using Flutter & BLoC**
