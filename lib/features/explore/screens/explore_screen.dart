import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../restaurants/bloc/restaurant_bloc.dart';
import '../../home/widgets/restaurant_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<String> _cuisines = [
    'All',
    'Italian',
    'Japanese',
    'French',
    'American',
    'Indian',
    'Chinese',
    'Mexican',
    'Thai',
    'Korean',
  ];

  final List<String> _priceRanges = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];

  String _selectedCuisine = 'All';
  double _minRating = 0;
  String? _selectedPriceRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explore & Filter'),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cuisine',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _cuisines.length,
                    itemBuilder: (context, index) {
                      final cuisine = _cuisines[index];
                      final isSelected = _selectedCuisine == cuisine;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(cuisine),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCuisine = cuisine;
                            });
                            _applyFilters();
                          },
                          backgroundColor: AppColors.surface,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Price Range',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: _priceRanges.map((price) {
                    final isSelected = _selectedPriceRange == price;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(price),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedPriceRange = selected ? price : null;
                          });
                          _applyFilters();
                        },
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Minimum Rating',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _minRating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        activeColor: AppColors.primary,
                        label: _minRating == 0 ? 'Any' : _minRating.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            _minRating = value;
                          });
                        },
                        onChangeEnd: (value) {
                          _applyFilters();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 60,
                      child: Text(
                        _minRating == 0 ? 'Any' : '${_minRating.toStringAsFixed(1)}+',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.surfaceLight),
          // Results
          Expanded(
            child: BlocBuilder<RestaurantBloc, RestaurantState>(
              builder: (context, state) {
                if (state is RestaurantLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is RestaurantLoaded) {
                  if (state.restaurants.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No restaurants found',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try adjusting your filters',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _resetFilters,
                            child: const Text('Reset Filters'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.restaurants.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: RestaurantCard(
                          restaurant: state.restaurants[index],
                          width: double.infinity,
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    context.read<RestaurantBloc>().add(
      FilterRestaurants(
        cuisine: _selectedCuisine == 'All' ? null : _selectedCuisine,
        minRating: _minRating > 0 ? _minRating : null,
        priceRange: _selectedPriceRange,
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedCuisine = 'All';
      _minRating = 0;
      _selectedPriceRange = null;
    });
    context.read<RestaurantBloc>().add(LoadRestaurants());
  }
}
