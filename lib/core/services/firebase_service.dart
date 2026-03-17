import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart' as app_user;
import '../models/restaurant.dart';
import '../models/reservation.dart';

class FirebaseService {
  // Firebase instances
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  static const String usersCollection = 'users';
  static const String restaurantsCollection = 'restaurants';
  static const String reservationsCollection = 'reservations';
  static const String reviewsCollection = 'reviews';
  static const String savedPlacesCollection = 'savedPlaces';

  // ==================== AUTHENTICATION ====================

  /// Sign up with email and password
  Future<app_user.User> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // Create Firebase user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await credential.user?.updateDisplayName(name);

      // Create user document in Firestore
      final user = app_user.User(
        id: credential.user!.uid,
        name: name,
        email: email,
        phone: phone,
      );

      await _firestore.collection(usersCollection).doc(user.id).set(user.toJson());

      return user;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign in with email and password
  Future<app_user.User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user data from Firestore
      final doc = await _firestore
          .collection(usersCollection)
          .doc(credential.user!.uid)
          .get();

      if (doc.exists) {
        return app_user.User.fromJson(doc.data()!);
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current user
  Future<app_user.User?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final doc = await _firestore
        .collection(usersCollection)
        .doc(firebaseUser.uid)
        .get();

    if (doc.exists) {
      return app_user.User.fromJson(doc.data()!);
    }
    return null;
  }

  /// Check if user is signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // ==================== RESTAURANTS ====================

  /// Get all restaurants
  Future<List<Restaurant>> getRestaurants() async {
    try {
      final snapshot = await _firestore
          .collection(restaurantsCollection)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Restaurant.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to load restaurants: $e');
    }
  }

  /// Get restaurant by ID
  Future<Restaurant> getRestaurantById(String id) async {
    try {
      final doc = await _firestore
          .collection(restaurantsCollection)
          .doc(id)
          .get();

      if (doc.exists) {
        return Restaurant.fromJson({...doc.data()!, 'id': doc.id});
      } else {
        throw Exception('Restaurant not found');
      }
    } catch (e) {
      throw Exception('Failed to load restaurant: $e');
    }
  }

  /// Search restaurants
  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final snapshot = await _firestore
          .collection(restaurantsCollection)
          .get();

      final restaurants = snapshot.docs
          .map((doc) => Restaurant.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Filter locally (Firestore doesn't support complex text search)
      return restaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
               restaurant.cuisine.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception('Failed to search restaurants: $e');
    }
  }

  /// Get trending restaurants
  Future<List<Restaurant>> getTrendingRestaurants() async {
    try {
      final snapshot = await _firestore
          .collection(restaurantsCollection)
          .where('isTrending', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => Restaurant.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to load trending restaurants: $e');
    }
  }

  /// Get popular restaurants
  Future<List<Restaurant>> getPopularRestaurants() async {
    try {
      final snapshot = await _firestore
          .collection(restaurantsCollection)
          .where('isPopular', isEqualTo: true)
          .orderBy('reviewCount', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => Restaurant.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to load popular restaurants: $e');
    }
  }

  /// Get reviews for a restaurant
  Future<List<Review>> getRestaurantReviews(String restaurantId) async {
    try {
      final snapshot = await _firestore
          .collection(restaurantsCollection)
          .doc(restaurantId)
          .collection(reviewsCollection)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Review.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  }

  // ==================== RESERVATIONS ====================

  /// Create a reservation
  Future<Reservation> createReservation(Reservation reservation) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      final docRef = await _firestore
          .collection(reservationsCollection)
          .add(reservation.toJson());

      final doc = await docRef.get();
      return Reservation.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw Exception('Failed to create reservation: $e');
    }
  }

  /// Get user reservations
  Future<List<Reservation>> getUserReservations() async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      final snapshot = await _firestore
          .collection(reservationsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => Reservation.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to load reservations: $e');
    }
  }

  /// Cancel a reservation
  Future<void> cancelReservation(String reservationId) async {
    try {
      await _firestore
          .collection(reservationsCollection)
          .doc(reservationId)
          .update({'status': 'cancelled'});
    } catch (e) {
      throw Exception('Failed to cancel reservation: $e');
    }
  }

  /// Update reservation
  Future<void> updateReservation(Reservation reservation) async {
    try {
      await _firestore
          .collection(reservationsCollection)
          .doc(reservation.id)
          .update(reservation.toJson());
    } catch (e) {
      throw Exception('Failed to update reservation: $e');
    }
  }

  // ==================== SAVED PLACES ====================

  /// Save a restaurant
  Future<void> saveRestaurant(String restaurantId) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(savedPlacesCollection)
          .doc(restaurantId)
          .set({
        'restaurantId': restaurantId,
        'savedAt': FieldValue.serverTimestamp(),
      });

      // Also update user document
      await _firestore.collection(usersCollection).doc(userId).update({
        'savedPlaces': FieldValue.arrayUnion([restaurantId]),
      });
    } catch (e) {
      throw Exception('Failed to save restaurant: $e');
    }
  }

  /// Remove saved restaurant
  Future<void> removeSavedRestaurant(String restaurantId) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(savedPlacesCollection)
          .doc(restaurantId)
          .delete();

      // Also update user document
      await _firestore.collection(usersCollection).doc(userId).update({
        'savedPlaces': FieldValue.arrayRemove([restaurantId]),
      });
    } catch (e) {
      throw Exception('Failed to remove saved restaurant: $e');
    }
  }

  /// Get saved restaurants
  Future<List<Restaurant>> getSavedRestaurants() async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      final snapshot = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(savedPlacesCollection)
          .get();

      final restaurantIds = snapshot.docs
          .map((doc) => doc.data()['restaurantId'] as String)
          .toList();

      if (restaurantIds.isEmpty) return [];

      // Get restaurant details
      final restaurants = <Restaurant>[];
      for (final id in restaurantIds) {
        try {
          final restaurant = await getRestaurantById(id);
          restaurants.add(restaurant);
        } catch (e) {
          // Skip if restaurant not found
          continue;
        }
      }

      return restaurants;
    } catch (e) {
      throw Exception('Failed to load saved restaurants: $e');
    }
  }

  /// Check if restaurant is saved
  Future<bool> isRestaurantSaved(String restaurantId) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) return false;

      final doc = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(savedPlacesCollection)
          .doc(restaurantId)
          .get();

      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // ==================== USER PROFILE ====================

  /// Update user profile
  Future<void> updateUserProfile(app_user.User user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.id)
          .update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Upload profile picture
  Future<String> uploadProfilePicture(String userId, String filePath) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$userId.jpg');
      await ref.putFile(filePath as dynamic);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  // ==================== HELPER METHODS ====================

  String _handleAuthException(dynamic e) {
    if (e is firebase_auth.FirebaseAuthException) {
      switch (e.code) {
        case 'weak-password':
          return 'The password is too weak';
        case 'email-already-in-use':
          return 'An account already exists with this email';
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Wrong password';
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-disabled':
          return 'This account has been disabled';
        default:
          return 'Authentication error: ${e.message}';
      }
    }
    return e.toString();
  }
}
