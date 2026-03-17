import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/restaurant.dart';

// Events
abstract class RestaurantEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRestaurants extends RestaurantEvent {}

class SearchRestaurants extends RestaurantEvent {
  final String query;
  SearchRestaurants(this.query);
  
  @override
  List<Object?> get props => [query];
}

class FilterRestaurants extends RestaurantEvent {
  final String? cuisine;
  final double? minRating;
  final String? priceRange;
  
  FilterRestaurants({this.cuisine, this.minRating, this.priceRange});
  
  @override
  List<Object?> get props => [cuisine, minRating, priceRange];
}

class LoadRestaurantDetails extends RestaurantEvent {
  final String restaurantId;
  LoadRestaurantDetails(this.restaurantId);
  
  @override
  List<Object?> get props => [restaurantId];
}

// States
abstract class RestaurantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  final List<Restaurant> trending;
  final List<Restaurant> popular;
  
  RestaurantLoaded({
    required this.restaurants,
    required this.trending,
    required this.popular,
  });
  
  @override
  List<Object?> get props => [restaurants, trending, popular];
}

class RestaurantDetailsLoaded extends RestaurantState {
  final Restaurant restaurant;
  final List<Review> reviews;
  
  RestaurantDetailsLoaded({
    required this.restaurant,
    required this.reviews,
  });
  
  @override
  List<Object?> get props => [restaurant, reviews];
}

class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc() : super(RestaurantInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<SearchRestaurants>(_onSearchRestaurants);
    on<FilterRestaurants>(_onFilterRestaurants);
    on<LoadRestaurantDetails>(_onLoadRestaurantDetails);
  }

  final List<Restaurant> _mockRestaurants = [
    Restaurant(
      id: '1',
      name: 'Lumina Bistro',
      cuisine: 'Italian',
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
      rating: 4.5,
      reviewCount: 128,
      priceRange: '\$\$\$',
      address: '123 Main St, City',
      description: 'An intimate space bringing modern twists to classic Italian dishes.',
      isPopular: true,
      isTrending: true,
      distance: '2.3 km',
      amenities: ['Wi-Fi', 'Outdoor Seating', 'Parking'],
    ),
    Restaurant(
      id: '2',
      name: 'The Rustic Hearth',
      cuisine: 'American',
      imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      rating: 4.3,
      reviewCount: 89,
      priceRange: '\$\$',
      address: '456 Oak Ave, City',
      description: 'Comfort food with a gourmet twist in a cozy atmosphere.',
      isPopular: true,
      distance: '1.8 km',
      amenities: ['Wi-Fi', 'Live Music'],
    ),
    Restaurant(
      id: '3',
      name: 'Sushi-Zen',
      cuisine: 'Japanese',
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
      rating: 4.8,
      reviewCount: 234,
      priceRange: '\$\$\$\$',
      address: '789 Elm St, City',
      description: 'Authentic Japanese cuisine with the freshest ingredients.',
      isTrending: true,
      distance: '3.1 km',
      amenities: ['Wi-Fi', 'Private Dining'],
    ),
    Restaurant(
      id: '4',
      name: 'Lumiere Kitchen',
      cuisine: 'French',
      imageUrl: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800',
      rating: 4.7,
      reviewCount: 156,
      priceRange: '\$\$\$\$',
      address: '321 Pine Rd, City',
      description: 'Classic French cuisine in an elegant setting.',
      isPopular: true,
      isTrending: true,
      distance: '4.2 km',
      amenities: ['Wi-Fi', 'Valet Parking', 'Wine Cellar'],
    ),
    Restaurant(
      id: '5',
      name: 'Spice Route',
      cuisine: 'Indian',
      imageUrl: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
      rating: 4.4,
      reviewCount: 178,
      priceRange: '\$\$',
      address: '654 Maple Dr, City',
      description: 'Aromatic spices and traditional recipes from across India.',
      distance: '2.7 km',
      amenities: ['Wi-Fi', 'Outdoor Seating'],
    ),
    Restaurant(
      id: '6',
      name: 'The Golden Wok',
      cuisine: 'Chinese',
      imageUrl: 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?w=800',
      rating: 4.2,
      reviewCount: 92,
      priceRange: '\$\$',
      address: '987 Cedar Ln, City',
      description: 'Authentic Cantonese and Szechuan flavors.',
      distance: '3.5 km',
      amenities: ['Wi-Fi', 'Delivery'],
    ),
  ];

  Future<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final trending = _mockRestaurants.where((r) => r.isTrending).toList();
      final popular = _mockRestaurants.where((r) => r.isPopular).toList();
      
      emit(RestaurantLoaded(
        restaurants: _mockRestaurants,
        trending: trending,
        popular: popular,
      ));
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  Future<void> _onSearchRestaurants(
    SearchRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final filtered = _mockRestaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(event.query.toLowerCase()) ||
               restaurant.cuisine.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
      
      final trending = filtered.where((r) => r.isTrending).toList();
      final popular = filtered.where((r) => r.isPopular).toList();
      
      emit(RestaurantLoaded(
        restaurants: filtered,
        trending: trending,
        popular: popular,
      ));
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  Future<void> _onFilterRestaurants(
    FilterRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      var filtered = _mockRestaurants;
      
      if (event.cuisine != null) {
        filtered = filtered.where((r) => r.cuisine == event.cuisine).toList();
      }
      
      if (event.minRating != null) {
        filtered = filtered.where((r) => r.rating >= event.minRating!).toList();
      }
      
      if (event.priceRange != null) {
        filtered = filtered.where((r) => r.priceRange == event.priceRange).toList();
      }
      
      final trending = filtered.where((r) => r.isTrending).toList();
      final popular = filtered.where((r) => r.isPopular).toList();
      
      emit(RestaurantLoaded(
        restaurants: filtered,
        trending: trending,
        popular: popular,
      ));
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  Future<void> _onLoadRestaurantDetails(
    LoadRestaurantDetails event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final restaurant = _mockRestaurants.firstWhere(
        (r) => r.id == event.restaurantId,
        orElse: () => _mockRestaurants.first,
      );
      
      final reviews = [
        Review(
          id: '1',
          userName: 'Sarah Miller',
          userAvatar: 'https://i.pravatar.cc/100?img=5',
          rating: 5.0,
          comment: 'Amazing food and great atmosphere! The pasta was incredible.',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Review(
          id: '2',
          userName: 'David Johnson',
          userAvatar: 'https://i.pravatar.cc/100?img=8',
          rating: 4.0,
          comment: 'Good experience overall. Service could be faster but the food was worth the wait.',
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];
      
      emit(RestaurantDetailsLoaded(
        restaurant: restaurant,
        reviews: reviews,
      ));
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }
}
