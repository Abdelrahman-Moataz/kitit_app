import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/restaurant.dart';

// Events
abstract class SavedPlacesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSavedPlaces extends SavedPlacesEvent {}

class ToggleSavedPlace extends SavedPlacesEvent {
  final Restaurant restaurant;
  ToggleSavedPlace(this.restaurant);
  
  @override
  List<Object?> get props => [restaurant];
}

class RemoveSavedPlace extends SavedPlacesEvent {
  final String restaurantId;
  RemoveSavedPlace(this.restaurantId);
  
  @override
  List<Object?> get props => [restaurantId];
}

// States
abstract class SavedPlacesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavedPlacesInitial extends SavedPlacesState {}

class SavedPlacesLoading extends SavedPlacesState {}

class SavedPlacesLoaded extends SavedPlacesState {
  final List<Restaurant> savedPlaces;
  final Set<String> savedIds;
  
  SavedPlacesLoaded({
    required this.savedPlaces,
    required this.savedIds,
  });
  
  @override
  List<Object?> get props => [savedPlaces, savedIds];
  
  bool isSaved(String restaurantId) => savedIds.contains(restaurantId);
}

class SavedPlacesError extends SavedPlacesState {
  final String message;
  SavedPlacesError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class SavedPlacesBloc extends Bloc<SavedPlacesEvent, SavedPlacesState> {
  final List<Restaurant> _savedPlaces = [];

  SavedPlacesBloc() : super(SavedPlacesInitial()) {
    on<LoadSavedPlaces>(_onLoadSavedPlaces);
    on<ToggleSavedPlace>(_onToggleSavedPlace);
    on<RemoveSavedPlace>(_onRemoveSavedPlace);
  }

  Future<void> _onLoadSavedPlaces(
    LoadSavedPlaces event,
    Emitter<SavedPlacesState> emit,
  ) async {
    emit(SavedPlacesLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final savedIds = _savedPlaces.map((r) => r.id).toSet();
      
      emit(SavedPlacesLoaded(
        savedPlaces: _savedPlaces,
        savedIds: savedIds,
      ));
    } catch (e) {
      emit(SavedPlacesError(e.toString()));
    }
  }

  Future<void> _onToggleSavedPlace(
    ToggleSavedPlace event,
    Emitter<SavedPlacesState> emit,
  ) async {
    try {
      final index = _savedPlaces.indexWhere((r) => r.id == event.restaurant.id);
      
      if (index != -1) {
        _savedPlaces.removeAt(index);
      } else {
        _savedPlaces.add(event.restaurant);
      }
      
      add(LoadSavedPlaces());
    } catch (e) {
      emit(SavedPlacesError(e.toString()));
    }
  }

  Future<void> _onRemoveSavedPlace(
    RemoveSavedPlace event,
    Emitter<SavedPlacesState> emit,
  ) async {
    try {
      _savedPlaces.removeWhere((r) => r.id == event.restaurantId);
      add(LoadSavedPlaces());
    } catch (e) {
      emit(SavedPlacesError(e.toString()));
    }
  }
}
