import 'package:flutter/material.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/restaurants/screens/restaurant_profile_screen.dart';
import '../../features/reservations/screens/reservation_flow_screen.dart';
import '../../features/reservations/screens/my_reservations_screen.dart';
import '../../features/saved_places/screens/saved_places_screen.dart';
import '../../features/profile/screens/user_profile_screen.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/rating/screens/rate_experience_screen.dart';
import '../../features/payment/screens/payment_screen.dart';

class AppRouter {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String restaurantProfile = '/restaurant-profile';
  static const String reservationFlow = '/reservation-flow';
  static const String myReservations = '/my-reservations';
  static const String savedPlaces = '/saved-places';
  static const String userProfile = '/user-profile';
  static const String explore = '/explore';
  static const String rateExperience = '/rate-experience';
  static const String payment = '/payment';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case restaurantProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => RestaurantProfileScreen(
            restaurantId: args?['restaurantId'] ?? '',
          ),
        );
      
      case reservationFlow:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ReservationFlowScreen(
            restaurantId: args?['restaurantId'] ?? '',
          ),
        );
      
      case myReservations:
        return MaterialPageRoute(builder: (_) => const MyReservationsScreen());
      
      case savedPlaces:
        return MaterialPageRoute(builder: (_) => const SavedPlacesScreen());
      
      case userProfile:
        return MaterialPageRoute(builder: (_) => const UserProfileScreen());
      
      case explore:
        return MaterialPageRoute(builder: (_) => const ExploreScreen());
      
      case rateExperience:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => RateExperienceScreen(
            reservationId: args?['reservationId'] ?? '',
          ),
        );
      
      case payment:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(
            reservationData: args?['reservationData'] ?? {},
          ),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}
