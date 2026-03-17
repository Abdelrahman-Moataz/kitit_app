class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String? address;
  final List<String> savedPlaces;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.address,
    this.savedPlaces = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'],
      address: json['address'],
      savedPlaces: List<String>.from(json['savedPlaces'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'address': address,
      'savedPlaces': savedPlaces,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? address,
    List<String>? savedPlaces,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      savedPlaces: savedPlaces ?? this.savedPlaces,
    );
  }
}
