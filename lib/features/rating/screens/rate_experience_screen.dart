import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_router.dart';

class RateExperienceScreen extends StatefulWidget {
  final String reservationId;
  
  const RateExperienceScreen({super.key, required this.reservationId});

  @override
  State<RateExperienceScreen> createState() => _RateExperienceScreenState();
}

class _RateExperienceScreenState extends State<RateExperienceScreen> {
  double _rating = 0;
  final _reviewController = TextEditingController();
  
  final Map<String, double> _categories = {
    'Food Quality': 0,
    'Service': 0,
    'Ambiance': 0,
    'Value for Money': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rate Your Experience'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lumina Bistro',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Italian • \$\$\$',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Overall Rating
            const Text(
              'Overall Rating',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _rating = (index + 1).toDouble();
                          });
                        },
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          size: 48,
                          color: AppColors.star,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getRatingText(_rating),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Category Ratings
            const Text(
              'Rate Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ..._categories.keys.map((category) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _categories[category] = (index + 1).toDouble();
                            });
                          },
                          child: Icon(
                            index < _categories[category]! ? Icons.star : Icons.star_border,
                            size: 32,
                            color: AppColors.star,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: 24),
            
            // Written Review
            const Text(
              'Write a Review',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              maxLines: 6,
              maxLength: 500,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Share your experience with others...',
                counterStyle: TextStyle(color: AppColors.textTertiary),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _rating > 0 ? _submitReview : null,
                child: const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating == 0) return 'Tap to rate';
    if (rating == 1) return 'Poor';
    if (rating == 2) return 'Fair';
    if (rating == 3) return 'Good';
    if (rating == 4) return 'Very Good';
    return 'Excellent';
  }

  void _submitReview() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide an overall rating'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // TODO: Submit review to Firebase

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your review!'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.home,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
