# Implementation Guide

This guide will help you understand and extend the Kitit Flutter app.

## Project Structure Overview

### Core Directory (`lib/core/`)

This contains shared resources used throughout the app:

**1. Models (`core/models/`)**
- `restaurant.dart` - Restaurant and Review data models
- `reservation.dart` - Reservation data model with status enum
- `user.dart` - User profile data model

**2. Theme (`core/theme/`)**
- `app_theme.dart` - Complete theme configuration including:
  - AppColors class with all color constants
  - AppTheme.darkTheme with Material 3 dark theme
  - Text styles, button styles, input decoration

**3. Routes (`core/routes/`)**
- `app_router.dart` - Centralized navigation using named routes
- All route constants defined as static strings
- `onGenerateRoute` handles all navigation logic

### Features Directory (`lib/features/`)

Each feature is self-contained with its own BLoC, screens, and widgets.

## Implementing Remaining Screens

### 1. Reservation Flow Screen

**Location:** `lib/features/reservations/screens/reservation_flow_screen.dart`

**Current state:** Basic stub

**To implement:**

```dart
// Add these states to track reservation steps
enum ReservationStep { date, time, guests, details, confirm }

class _ReservationFlowScreenState extends State<ReservationFlowScreen> {
  ReservationStep _currentStep = ReservationStep.date;
  DateTime? _selectedDate;
  String? _selectedTime;
  int _guestCount = 2;
  
  // Build step-by-step wizard UI
  // Use PageView or IndexedStack
  // Add "Next" and "Back" buttons
  // On final step, create reservation using ReservationBloc
}
```

**UI Components:**
- Date picker (use `showDatePicker`)
- Time slots (grid of buttons)
- Guest counter (+/- buttons)
- Special requests text field
- Confirmation summary

### 2. My Reservations Screen

**Location:** `lib/features/reservations/screens/my_reservations_screen.dart`

**To implement:**

```dart
class MyReservationsScreen extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    // Load reservations
    context.read<ReservationBloc>().add(LoadReservations());
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationBloc, ReservationState>(
      builder: (context, state) {
        if (state is ReservationLoaded) {
          // Show tabs: Upcoming / Past
          // Use TabBarView
          // Display reservation cards
          // Add cancel button for upcoming
          // Add "Rate" button for completed
        }
      },
    );
  }
}
```

**UI Components:**
- Tab bar (Upcoming / Past)
- Reservation cards showing:
  - Restaurant image and name
  - Date, time, guest count
  - Status badge
  - Action buttons (Cancel, Rate, View Details)

### 3. Saved Places Screen

**Location:** `lib/features/saved_places/screens/saved_places_screen.dart`

**To implement:**

```dart
class SavedPlacesScreen extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    context.read<SavedPlacesBloc>().add(LoadSavedPlaces());
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedPlacesBloc, SavedPlacesState>(
      builder: (context, state) {
        if (state is SavedPlacesLoaded) {
          // Display grid or list of saved restaurants
          // Reuse RestaurantCard widget from home
          // Add remove button
        }
      },
    );
  }
}
```

### 4. User Profile Screen

**Location:** `lib/features/profile/screens/user_profile_screen.dart`

**To implement:**

```dart
// Display user info from AuthBloc
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthAuthenticated) {
      final user = state.user;
      // Show avatar, name, email
      // Settings list:
      // - Edit Profile
      // - My Reservations
      // - Saved Places
      // - Payment Methods
      // - Notifications
      // - Help & Support
      // - Logout button
    }
  },
);
```

**UI Components:**
- Profile header with avatar
- List of settings options
- Logout button at bottom

### 5. Rate Experience Screen

**Location:** `lib/features/rating/screens/rate_experience_screen.dart`

**To implement:**

```dart
class _RateExperienceScreenState extends State<RateExperienceScreen> {
  double _rating = 0;
  final _reviewController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Restaurant info
          // Star rating (use custom widget or package)
          // Review text field
          // Photo upload (optional)
          // Submit button
        ],
      ),
    );
  }
}
```

**UI Components:**
- Restaurant header (image, name)
- Star rating (1-5 stars, interactive)
- Multi-line text field for review
- Optional: Image picker for photos
- Submit button

### 6. Payment Screen

**Location:** `lib/features/payment/screens/payment_screen.dart`

**To implement:**

```dart
class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'card';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Reservation summary
          // Total amount
          // Payment method selector (Card / Apple Pay / Google Pay)
          // Card input fields (if card selected)
          // Checkout button
        ],
      ),
    );
  }
}
```

**UI Components:**
- Reservation summary card
- Payment method buttons
- Card form (number, expiry, CVV)
- Total amount display
- Pay button

### 7. Explore & Filter Screen

**Location:** `lib/features/explore/screens/explore_screen.dart`

**To implement:**

```dart
class _ExploreScreenState extends State<ExploreScreen> {
  List<String> _selectedCuisines = [];
  double _minRating = 0;
  String? _priceRange;
  
  void _applyFilters() {
    context.read<RestaurantBloc>().add(
      FilterRestaurants(
        cuisine: _selectedCuisines.isEmpty ? null : _selectedCuisines.first,
        minRating: _minRating,
        priceRange: _priceRange,
      ),
    );
  }
}
```

**UI Components:**
- Cuisine filter chips (multi-select)
- Rating slider (0-5 stars)
- Price range buttons ($, $$, $$$, $$$$)
- Distance radius slider
- Apply filters button
- Clear filters button

## Adding API Integration

### Step 1: Create API Service

Create `lib/core/services/api_service.dart`:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://your-api.com/api';
  
  Future<List<Restaurant>> getRestaurants() async {
    final response = await http.get(Uri.parse('$baseUrl/restaurants'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }
  
  Future<Reservation> createReservation(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservations'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    
    if (response.statusCode == 201) {
      return Reservation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create reservation');
    }
  }
}
```

### Step 2: Add to pubspec.yaml

```yaml
dependencies:
  http: ^1.1.0  # or dio: ^5.3.0 for more features
```

### Step 3: Update BLoCs

Replace mock data with API calls:

```dart
// In RestaurantBloc
final _apiService = ApiService();

Future<void> _onLoadRestaurants(
  LoadRestaurants event,
  Emitter<RestaurantState> emit,
) async {
  emit(RestaurantLoading());
  
  try {
    final restaurants = await _apiService.getRestaurants();
    final trending = restaurants.where((r) => r.isTrending).toList();
    final popular = restaurants.where((r) => r.isPopular).toList();
    
    emit(RestaurantLoaded(
      restaurants: restaurants,
      trending: trending,
      popular: popular,
    ));
  } catch (e) {
    emit(RestaurantError(e.toString()));
  }
}
```

## Adding Persistence

### Using Shared Preferences

**Add to pubspec.yaml:**
```yaml
dependencies:
  shared_preferences: ^2.2.2
```

**Create storage service:**

```dart
// lib/core/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
  }
  
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('user_id');
    if (id == null) return null;
    
    return User(
      id: id,
      name: prefs.getString('user_name') ?? '',
      email: prefs.getString('user_email') ?? '',
      phone: prefs.getString('user_phone') ?? '',
    );
  }
  
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
```

**Update AuthBloc:**

```dart
Future<void> _onLoginRequested(
  LoginRequested event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());
  
  try {
    // API call
    final user = await _apiService.login(event.email, event.password);
    
    // Save to local storage
    await StorageService.saveUser(user);
    
    emit(AuthAuthenticated(user));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}
```

## UI Enhancements

### Adding Loading Skeletons

**Add to pubspec.yaml:**
```yaml
dependencies:
  shimmer: ^3.0.0
```

**Create skeleton widget:**

```dart
// lib/core/widgets/skeleton_loader.dart
import 'package:shimmer/shimmer.dart';

class RestaurantCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceLight,
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
```

### Adding Animations

**Hero Transitions:**

```dart
// In RestaurantCard
Hero(
  tag: 'restaurant-${restaurant.id}',
  child: Image.network(restaurant.imageUrl),
)

// In RestaurantProfileScreen
Hero(
  tag: 'restaurant-${widget.restaurantId}',
  child: Image.network(restaurant.imageUrl),
)
```

**Page Transitions:**

```dart
// In app_router.dart
return PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) {
    return RestaurantProfileScreen(restaurantId: restaurantId);
  },
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(opacity: animation, child: child);
  },
);
```

## Testing

### Unit Testing BLoCs

```dart
// test/features/auth/bloc/auth_bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;

    setUp(() {
      authBloc = AuthBloc();
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () => authBloc,
      act: (bloc) => bloc.add(
        LoginRequested(email: 'test@test.com', password: 'password'),
      ),
      expect: () => [
        AuthLoading(),
        isA<AuthAuthenticated>(),
      ],
    );
  });
}
```

### Widget Testing

```dart
// test/features/auth/screens/login_screen_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginScreen has email and password fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen()),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
  });
}
```

## Deployment Checklist

### Before Release

- [ ] Replace all mock data with real API calls
- [ ] Add error handling for network failures
- [ ] Implement user authentication persistence
- [ ] Add loading states and skeleton screens
- [ ] Test on both iOS and Android
- [ ] Add app icons and splash screen
- [ ] Configure app permissions (camera, storage, location)
- [ ] Add analytics (Firebase Analytics, Mixpanel)
- [ ] Add crash reporting (Firebase Crashlytics, Sentry)
- [ ] Test payment integration
- [ ] Add push notifications
- [ ] Optimize images and assets
- [ ] Add obfuscation for release builds
- [ ] Test deep linking
- [ ] Add privacy policy and terms of service
- [ ] Submit to App Store / Play Store

## Performance Tips

1. **Use const constructors** wherever possible
2. **Lazy load images** with `cached_network_image`
3. **Paginate** restaurant lists for large datasets
4. **Debounce** search input to reduce API calls
5. **Cache** frequently accessed data
6. **Optimize** build methods (avoid expensive operations)
7. **Use** `ListView.builder` instead of `ListView` for long lists

## Common Patterns

### Error Handling

```dart
try {
  // API call
} on SocketException {
  emit(ErrorState('No internet connection'));
} on TimeoutException {
  emit(ErrorState('Request timed out'));
} catch (e) {
  emit(ErrorState('An error occurred: ${e.toString()}'));
}
```

### Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    context.read<RestaurantBloc>().add(LoadRestaurants());
    await Future.delayed(Duration(milliseconds: 500));
  },
  child: ListView(...),
)
```

### Infinite Scroll

```dart
ScrollController _scrollController = ScrollController();

@override
void initState() {
  super.initState();
  _scrollController.addListener(_onScroll);
}

void _onScroll() {
  if (_scrollController.position.pixels >= 
      _scrollController.position.maxScrollExtent - 200) {
    // Load more
    context.read<RestaurantBloc>().add(LoadMoreRestaurants());
  }
}
```

---

For more help, refer to:
- [Flutter Documentation](https://docs.flutter.dev)
- [BLoC Documentation](https://bloclibrary.dev)
- [Material Design 3](https://m3.material.io)
