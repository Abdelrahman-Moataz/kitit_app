import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/reservation.dart';
import '../../../core/routes/app_router.dart';
import '../bloc/reservation_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

class ReservationFlowScreen extends StatefulWidget {
  final String restaurantId;
  
  const ReservationFlowScreen({super.key, required this.restaurantId});

  @override
  State<ReservationFlowScreen> createState() => _ReservationFlowScreenState();
}

class _ReservationFlowScreenState extends State<ReservationFlowScreen> {
  int _currentStep = 0;
  DateTime? _selectedDate;
  String? _selectedTime;
  int _guestCount = 2;
  final _specialRequestsController = TextEditingController();

  final List<String> _timeSlots = [
    '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM',
    '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
    '5:00 PM', '5:30 PM', '6:00 PM', '6:30 PM',
    '7:00 PM', '7:30 PM', '8:00 PM', '8:30 PM',
    '9:00 PM', '9:30 PM', '10:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book a Table'),
        elevation: 0,
      ),
      body: BlocListener<ReservationBloc, ReservationState>(
        listener: (context, state) {
          if (state is ReservationCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reservation created successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.home,
              (route) => false,
            );
          } else if (state is ReservationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          _buildStepIndicator(0, 'Date', Icons.calendar_today),
          _buildStepLine(0),
          _buildStepIndicator(1, 'Time', Icons.access_time),
          _buildStepLine(1),
          _buildStepIndicator(2, 'Guests', Icons.people),
          _buildStepLine(2),
          _buildStepIndicator(3, 'Confirm', Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : AppColors.textTertiary,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isActive ? AppColors.primary : AppColors.surface,
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildDateSelection();
      case 1:
        return _buildTimeSelection();
      case 2:
        return _buildGuestSelection();
      case 3:
        return _buildConfirmation();
      default:
        return Container();
    }
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose your preferred dining date',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        CalendarDatePicker(
          initialDate: DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 90)),
          currentDate: _selectedDate,
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Date: ${DateFormat('MMMM dd, yyyy').format(_selectedDate!)}',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _timeSlots.length,
          itemBuilder: (context, index) {
            final time = _timeSlots[index];
            final isSelected = _selectedTime == time;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTime = time;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGuestSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Guests',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Date: ${DateFormat('MMM dd').format(_selectedDate!)} • $_selectedTime',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _guestCount > 1 ? () => setState(() => _guestCount--) : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.primary,
              iconSize: 48,
            ),
            const SizedBox(width: 32),
            Text(
              '$_guestCount',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 32),
            IconButton(
              onPressed: _guestCount < 20 ? () => setState(() => _guestCount++) : null,
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primary,
              iconSize: 48,
            ),
          ],
        ),
        const SizedBox(height: 48),
        const Text(
          'Special Requests',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _specialRequestsController,
          maxLines: 4,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Any dietary restrictions, allergies, or special occasions?',
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmation() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const Center(child: Text('Please log in to continue'));
        }

        final user = authState.user;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm Reservation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildConfirmationItem(
              Icons.calendar_today,
              'Date',
              DateFormat('MMMM dd, yyyy').format(_selectedDate!),
            ),
            _buildConfirmationItem(
              Icons.access_time,
              'Time',
              _selectedTime!,
            ),
            _buildConfirmationItem(
              Icons.people,
              'Guests',
              '$_guestCount ${_guestCount == 1 ? 'person' : 'people'}',
            ),
            if (_specialRequestsController.text.isNotEmpty)
              _buildConfirmationItem(
                Icons.note,
                'Special Requests',
                _specialRequestsController.text,
              ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  Text(
                    user.phone,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmationItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.surfaceLight),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? _handleNext : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(_currentStep == 3 ? 'Confirm Booking' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedDate != null;
      case 1:
        return _selectedTime != null;
      case 2:
        return _guestCount > 0;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      _createReservation();
    }
  }

  void _createReservation() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    final user = authState.user;
    final reservation = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.id,
      restaurantId: widget.restaurantId,
      restaurantName: 'Restaurant Name', // This should come from previous screen
      restaurantImage: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
      date: _selectedDate!,
      time: _selectedTime!,
      numberOfGuests: _guestCount,
      userName: user.name,
      userEmail: user.email,
      userPhone: user.phone,
      status: ReservationStatus.pending,
      specialRequests: _specialRequestsController.text.isEmpty 
          ? null 
          : _specialRequestsController.text,
    );

    context.read<ReservationBloc>().add(CreateReservation(reservation));
  }

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }
}
