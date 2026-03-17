import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/models/restaurant.dart';
import '../bloc/restaurant_bloc.dart';

class RestaurantProfileScreen extends StatefulWidget {
  final String restaurantId;
  
  const RestaurantProfileScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantProfileScreen> createState() => _RestaurantProfileScreenState();
}

class _RestaurantProfileScreenState extends State<RestaurantProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantBloc>().add(LoadRestaurantDetails(widget.restaurantId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestaurantDetailsLoaded) {
            return _buildRestaurantProfile(state.restaurant, state.reviews);
          }

          return const Center(child: Text('Error loading restaurant'));
        },
      ),
    );
  }

  Widget _buildRestaurantProfile(Restaurant restaurant, reviews) {
    return CustomScrollView(
      slivers: [
        // Header Image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              restaurant.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Restaurant Info
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.star, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${restaurant.rating}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${restaurant.reviewCount} reviews)',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${restaurant.cuisine} • ${restaurant.priceRange}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppColors.textTertiary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        restaurant.address,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'About',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  restaurant.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.reservationFlow,
                        arguments: {'restaurantId': restaurant.id},
                      );
                    },
                    child: const Text('Book a Table'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
