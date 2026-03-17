class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final String address;
  final String description;
  final List<String> imageGallery;
  final Map<String, String> openingHours;
  final List<String> amenities;
  final bool isPopular;
  final bool isTrending;
  final String distance;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.address,
    required this.description,
    this.imageGallery = const [],
    this.openingHours = const {},
    this.amenities = const [],
    this.isPopular = false,
    this.isTrending = false,
    this.distance = '',
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      cuisine: json['cuisine'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      priceRange: json['priceRange'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      imageGallery: List<String>.from(json['imageGallery'] ?? []),
      openingHours: Map<String, String>.from(json['openingHours'] ?? {}),
      amenities: List<String>.from(json['amenities'] ?? []),
      isPopular: json['isPopular'] ?? false,
      isTrending: json['isTrending'] ?? false,
      distance: json['distance'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceRange': priceRange,
      'address': address,
      'description': description,
      'imageGallery': imageGallery,
      'openingHours': openingHours,
      'amenities': amenities,
      'isPopular': isPopular,
      'isTrending': isTrending,
      'distance': distance,
    };
  }
}

class Review {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime date;
  final List<String> images;

  Review({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
    this.images = const [],
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
