import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/reservation.dart';

// Events
abstract class ReservationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadReservations extends ReservationEvent {}

class CreateReservation extends ReservationEvent {
  final Reservation reservation;
  CreateReservation(this.reservation);
  
  @override
  List<Object?> get props => [reservation];
}

class CancelReservation extends ReservationEvent {
  final String reservationId;
  CancelReservation(this.reservationId);
  
  @override
  List<Object?> get props => [reservationId];
}

class UpdateReservation extends ReservationEvent {
  final Reservation reservation;
  UpdateReservation(this.reservation);
  
  @override
  List<Object?> get props => [reservation];
}

// States
abstract class ReservationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationLoaded extends ReservationState {
  final List<Reservation> reservations;
  final List<Reservation> upcoming;
  final List<Reservation> past;
  
  ReservationLoaded({
    required this.reservations,
    required this.upcoming,
    required this.past,
  });
  
  @override
  List<Object?> get props => [reservations, upcoming, past];
}

class ReservationCreated extends ReservationState {
  final Reservation reservation;
  ReservationCreated(this.reservation);
  
  @override
  List<Object?> get props => [reservation];
}

class ReservationError extends ReservationState {
  final String message;
  ReservationError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final List<Reservation> _reservations = [];

  ReservationBloc() : super(ReservationInitial()) {
    on<LoadReservations>(_onLoadReservations);
    on<CreateReservation>(_onCreateReservation);
    on<CancelReservation>(_onCancelReservation);
    on<UpdateReservation>(_onUpdateReservation);
    
    _initializeMockData();
  }

  void _initializeMockData() {
    _reservations.addAll([
      Reservation(
        id: '1',
        userId: '1',
        restaurantId: '1',
        restaurantName: 'Lumina Bistro',
        restaurantImage: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
        date: DateTime.now().add(const Duration(days: 3)),
        time: '19:30',
        numberOfGuests: 2,
        userName: 'Julian Casablancas',
        userEmail: 'julian@email.com',
        userPhone: '+1234567890',
        status: ReservationStatus.confirmed,
      ),
      Reservation(
        id: '2',
        userId: '1',
        restaurantId: '3',
        restaurantName: 'Sushi-Zen',
        restaurantImage: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
        date: DateTime.now().add(const Duration(days: 7)),
        time: '20:00',
        numberOfGuests: 4,
        userName: 'Julian Casablancas',
        userEmail: 'julian@email.com',
        userPhone: '+1234567890',
        status: ReservationStatus.confirmed,
      ),
      Reservation(
        id: '3',
        userId: '1',
        restaurantId: '2',
        restaurantName: 'The Rustic Hearth',
        restaurantImage: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
        date: DateTime.now().subtract(const Duration(days: 5)),
        time: '18:00',
        numberOfGuests: 2,
        userName: 'Julian Casablancas',
        userEmail: 'julian@email.com',
        userPhone: '+1234567890',
        status: ReservationStatus.completed,
      ),
    ]);
  }

  Future<void> _onLoadReservations(
    LoadReservations event,
    Emitter<ReservationState> emit,
  ) async {
    emit(ReservationLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final now = DateTime.now();
      final upcoming = _reservations.where((r) {
        return r.date.isAfter(now) && r.status != ReservationStatus.cancelled;
      }).toList()
        ..sort((a, b) => a.date.compareTo(b.date));
      
      final past = _reservations.where((r) {
        return r.date.isBefore(now) || r.status == ReservationStatus.cancelled;
      }).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      
      emit(ReservationLoaded(
        reservations: _reservations,
        upcoming: upcoming,
        past: past,
      ));
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }

  Future<void> _onCreateReservation(
    CreateReservation event,
    Emitter<ReservationState> emit,
  ) async {
    emit(ReservationLoading());
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _reservations.add(event.reservation);
      
      emit(ReservationCreated(event.reservation));
      
      add(LoadReservations());
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }

  Future<void> _onCancelReservation(
    CancelReservation event,
    Emitter<ReservationState> emit,
  ) async {
    emit(ReservationLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _reservations.indexWhere((r) => r.id == event.reservationId);
      if (index != -1) {
        _reservations[index] = Reservation(
          id: _reservations[index].id,
          userId: _reservations[index].userId,
          restaurantId: _reservations[index].restaurantId,
          restaurantName: _reservations[index].restaurantName,
          restaurantImage: _reservations[index].restaurantImage,
          date: _reservations[index].date,
          time: _reservations[index].time,
          numberOfGuests: _reservations[index].numberOfGuests,
          userName: _reservations[index].userName,
          userEmail: _reservations[index].userEmail,
          userPhone: _reservations[index].userPhone,
          status: ReservationStatus.cancelled,
        );
      }
      
      add(LoadReservations());
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }

  Future<void> _onUpdateReservation(
    UpdateReservation event,
    Emitter<ReservationState> emit,
  ) async {
    emit(ReservationLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _reservations.indexWhere((r) => r.id == event.reservation.id);
      if (index != -1) {
        _reservations[index] = event.reservation;
      }
      
      add(LoadReservations());
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }
}
