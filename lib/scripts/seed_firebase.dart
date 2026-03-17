// Run this script to populate Firebase with sample data
// Usage: dart run lib/scripts/seed_firebase.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp();
  
  final firestore = FirebaseFirestore.instance;
  
  print('🌱 Seeding Firebase with sample data...\n');
  
  // Sample restaurants
  final restaurants = [
    {
      'name': 'Lumina Bistro',
      'cuisine': 'Italian',
      'imageUrl': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
      'rating': 4.5,
      'reviewCount': 128,
      'priceRange': '\$\$\$',
      'address': '123 Main St, Downtown',
      'description': 'An intimate space bringing modern twists to classic Italian dishes with locally sourced ingredients.',
      'imageGallery': [
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      ],
      'openingHours': {
        'Monday': '11:00 AM - 10:00 PM',
        'Tuesday': '11:00 AM - 10:00 PM',
        'Wednesday': '11:00 AM - 10:00 PM',
        'Thursday': '11:00 AM - 10:00 PM',
        'Friday': '11:00 AM - 11:00 PM',
        'Saturday': '10:00 AM - 11:00 PM',
        'Sunday': '10:00 AM - 9:00 PM',
      },
      'amenities': ['Wi-Fi', 'Outdoor Seating', 'Parking', 'Wheelchair Accessible'],
      'isPopular': true,
      'isTrending': true,
      'distance': '2.3 km',
    },
    {
      'name': 'The Rustic Hearth',
      'cuisine': 'American',
      'imageUrl': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      'rating': 4.3,
      'reviewCount': 89,
      'priceRange': '\$\$',
      'address': '456 Oak Ave, Midtown',
      'description': 'Comfort food with a gourmet twist in a cozy, rustic atmosphere.',
      'imageGallery': [
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      ],
      'openingHours': {
        'Monday': '12:00 PM - 9:00 PM',
        'Tuesday': '12:00 PM - 9:00 PM',
        'Wednesday': '12:00 PM - 9:00 PM',
        'Thursday': '12:00 PM - 9:00 PM',
        'Friday': '12:00 PM - 10:00 PM',
        'Saturday': '11:00 AM - 10:00 PM',
        'Sunday': '11:00 AM - 8:00 PM',
      },
      'amenities': ['Wi-Fi', 'Live Music', 'Full Bar'],
      'isPopular': true,
      'isTrending': false,
      'distance': '1.8 km',
    },
    {
      'name': 'Sushi-Zen',
      'cuisine': 'Japanese',
      'imageUrl': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
      'rating': 4.8,
      'reviewCount': 234,
      'priceRange': '\$\$\$\$',
      'address': '789 Elm St, Eastside',
      'description': 'Authentic Japanese cuisine with the freshest ingredients and traditional preparation methods.',
      'imageGallery': [
        'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
      ],
      'openingHours': {
        'Monday': 'Closed',
        'Tuesday': '5:00 PM - 10:00 PM',
        'Wednesday': '5:00 PM - 10:00 PM',
        'Thursday': '5:00 PM - 10:00 PM',
        'Friday': '5:00 PM - 11:00 PM',
        'Saturday': '5:00 PM - 11:00 PM',
        'Sunday': '5:00 PM - 9:00 PM',
      },
      'amenities': ['Wi-Fi', 'Private Dining', 'Sake Bar'],
      'isPopular': false,
      'isTrending': true,
      'distance': '3.1 km',
    },
    {
      'name': 'Lumiere Kitchen',
      'cuisine': 'French',
      'imageUrl': 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800',
      'rating': 4.7,
      'reviewCount': 156,
      'priceRange': '\$\$\$\$',
      'address': '321 Pine Rd, Uptown',
      'description': 'Classic French cuisine in an elegant setting with an extensive wine collection.',
      'imageGallery': [
        'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800',
      ],
      'openingHours': {
        'Monday': 'Closed',
        'Tuesday': '6:00 PM - 10:00 PM',
        'Wednesday': '6:00 PM - 10:00 PM',
        'Thursday': '6:00 PM - 10:00 PM',
        'Friday': '6:00 PM - 11:00 PM',
        'Saturday': '6:00 PM - 11:00 PM',
        'Sunday': '5:00 PM - 9:00 PM',
      },
      'amenities': ['Wi-Fi', 'Valet Parking', 'Wine Cellar', 'Dress Code'],
      'isPopular': true,
      'isTrending': true,
      'distance': '4.2 km',
    },
    {
      'name': 'Spice Route',
      'cuisine': 'Indian',
      'imageUrl': 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
      'rating': 4.4,
      'reviewCount': 178,
      'priceRange': '\$\$',
      'address': '654 Maple Dr, West End',
      'description': 'Aromatic spices and traditional recipes from across India, including vegetarian and vegan options.',
      'imageGallery': [
        'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
      ],
      'openingHours': {
        'Monday': '11:30 AM - 2:30 PM, 5:00 PM - 10:00 PM',
        'Tuesday': '11:30 AM - 2:30 PM, 5:00 PM - 10:00 PM',
        'Wednesday': '11:30 AM - 2:30 PM, 5:00 PM - 10:00 PM',
        'Thursday': '11:30 AM - 2:30 PM, 5:00 PM - 10:00 PM',
        'Friday': '11:30 AM - 2:30 PM, 5:00 PM - 10:30 PM',
        'Saturday': '12:00 PM - 10:30 PM',
        'Sunday': '12:00 PM - 9:00 PM',
      },
      'amenities': ['Wi-Fi', 'Outdoor Seating', 'Vegetarian Options', 'Delivery'],
      'isPopular': false,
      'isTrending': false,
      'distance': '2.7 km',
    },
    {
      'name': 'The Golden Wok',
      'cuisine': 'Chinese',
      'imageUrl': 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?w=800',
      'rating': 4.2,
      'reviewCount': 92,
      'priceRange': '\$\$',
      'address': '987 Cedar Ln, Chinatown',
      'description': 'Authentic Cantonese and Szechuan flavors with family-style dining options.',
      'imageGallery': [
        'https://images.unsplash.com/photo-1526318896980-cf78c088247c?w=800',
      ],
      'openingHours': {
        'Monday': '11:00 AM - 9:30 PM',
        'Tuesday': '11:00 AM - 9:30 PM',
        'Wednesday': '11:00 AM - 9:30 PM',
        'Thursday': '11:00 AM - 9:30 PM',
        'Friday': '11:00 AM - 10:00 PM',
        'Saturday': '11:00 AM - 10:00 PM',
        'Sunday': '11:00 AM - 9:00 PM',
      },
      'amenities': ['Wi-Fi', 'Delivery', 'Takeout', 'Family Style'],
      'isPopular': false,
      'isTrending': false,
      'distance': '3.5 km',
    },
  ];
  
  // Add restaurants
  print('📍 Adding restaurants...');
  for (final restaurant in restaurants) {
    final docRef = await firestore.collection('restaurants').add(restaurant);
    print('   ✓ Added: ${restaurant['name']} (ID: ${docRef.id})');
    
    // Add sample reviews for each restaurant
    final reviews = [
      {
        'userName': 'Sarah Miller',
        'userAvatar': 'https://i.pravatar.cc/100?img=5',
        'rating': 5.0,
        'comment': 'Amazing food and great atmosphere! Highly recommended.',
        'date': Timestamp.now(),
        'images': [],
      },
      {
        'userName': 'David Johnson',
        'userAvatar': 'https://i.pravatar.cc/100?img=8',
        'rating': 4.0,
        'comment': 'Good experience overall. Service could be faster but food was excellent.',
        'date': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
        'images': [],
      },
    ];
    
    for (final review in reviews) {
      await docRef.collection('reviews').add(review);
    }
    print('   ✓ Added reviews for ${restaurant['name']}');
  }
  
  print('\n✅ Sample data added successfully!');
  print('');
  print('📊 Summary:');
  print('   • ${restaurants.length} restaurants added');
  print('   • ${restaurants.length * 2} reviews added');
  print('');
  print('🚀 You can now run the app and see the data!');
}
