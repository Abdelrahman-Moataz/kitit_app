import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final Map<String, dynamic> reservationData;
  
  const PaymentScreen({super.key, required this.reservationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: const Center(child: Text('Reservation Payment')),
    );
  }
}
