import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/restaurants/bloc/restaurant_bloc.dart';
import 'features/reservations/bloc/reservation_bloc.dart';
import 'features/saved_places/bloc/saved_places_bloc.dart';

// MOCK MODE: Firebase is optional
// To enable Firebase, follow FIREBASE_SETUP.md
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase initialization is commented out - app will use mock data
  // Uncomment after setting up Firebase (see FIREBASE_SETUP.md)
  // await Firebase.initializeApp();
  
  runApp(const KititApp());
}

class KititApp extends StatelessWidget {
  const KititApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using mock mode (no Firebase service)
    // To enable Firebase, uncomment and follow FIREBASE_SETUP.md
    // final firebaseService = FirebaseService();
    
    return MultiBlocProvider(
      providers: [
        // Mock mode - BLoCs use local data
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => RestaurantBloc()..add(LoadRestaurants())),
        BlocProvider(create: (context) => ReservationBloc()),
        BlocProvider(create: (context) => SavedPlacesBloc()),
      ],
      child: MaterialApp(
        title: 'Kitit',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRouter.onboarding,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
