enum ReservationStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class Reservation {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final DateTime date;
  final String time;
  final int numberOfGuests;
  final String userName;
  final String userEmail;
  final String userPhone;
  final ReservationStatus status;
  final String? specialRequests;
  final double? totalAmount;

  Reservation({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.date,
    required this.time,
    required this.numberOfGuests,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.status,
    this.specialRequests,
    this.totalAmount,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      restaurantImage: json['restaurantImage'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      time: json['time'] ?? '',
      numberOfGuests: json['numberOfGuests'] ?? 1,
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userPhone: json['userPhone'] ?? '',
      status: ReservationStatus.values.firstWhere(
        (e) => e.toString() == 'ReservationStatus.${json['status']}',
        orElse: () => ReservationStatus.pending,
      ),
      specialRequests: json['specialRequests'],
      totalAmount: json['totalAmount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantImage': restaurantImage,
      'date': date.toIso8601String(),
      'time': time,
      'numberOfGuests': numberOfGuests,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'status': status.toString().split('.').last,
      'specialRequests': specialRequests,
      'totalAmount': totalAmount,
    };
  }

  String get statusText {
    switch (status) {
      case ReservationStatus.pending:
        return 'Pending';
      case ReservationStatus.confirmed:
        return 'Confirmed';
      case ReservationStatus.completed:
        return 'Completed';
      case ReservationStatus.cancelled:
        return 'Cancelled';
    }
  }
}
