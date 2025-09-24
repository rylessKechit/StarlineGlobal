import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/activity.dart';
import '../repositories/activity_repository.dart';

// ========== EVENTS ==========
abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class ActivityLoadRequested extends ActivityEvent {
  final int page;
  final int limit;
  final String? category;
  final String? search;
  final String? sortBy;

  const ActivityLoadRequested({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.search,
    this.sortBy,
  });

  @override
  List<Object?> get props => [page, limit, category, search, sortBy];
}

class ActivityFeaturedLoadRequested extends ActivityEvent {}

class ActivitySearchRequested extends ActivityEvent {
  final String query;
  final String? category;
  final String? sortBy;

  const ActivitySearchRequested({
    required this.query,
    this.category,
    this.sortBy,
  });

  @override
  List<Object?> get props => [query, category, sortBy];
}

class ActivityFilterChanged extends ActivityEvent {
  final String? category;
  final String? search;
  final String? sortBy;

  const ActivityFilterChanged({
    this.category,
    this.search,
    this.sortBy,
  });

  @override
  List<Object?> get props => [category, search, sortBy];
}

class ActivityRefreshRequested extends ActivityEvent {
  final String? category;
  final String? search;
  final String? sortBy;

  const ActivityRefreshRequested({
    this.category,
    this.search,
    this.sortBy,
  });

  @override
  List<Object?> get props => [category, search, sortBy];
}

// ========== STATES ==========
abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final List<Activity> activities;
  final bool hasReachedMax;

  const ActivityLoaded({
    required this.activities,
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [activities, hasReachedMax];
}

class ActivityFeaturedLoaded extends ActivityState {
  final List<Activity> activities;

  const ActivityFeaturedLoaded({required this.activities});

  @override
  List<Object> get props => [activities];
}

class ActivityError extends ActivityState {
  final String message;

  const ActivityError({required this.message});

  @override
  List<Object> get props => [message];
}

// ========== BLOC ==========
class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository _activityRepository;

  ActivityBloc({required ActivityRepository activityRepository})
      : _activityRepository = activityRepository,
        super(ActivityInitial()) {
    
    on<ActivityLoadRequested>(_onLoadRequested);
    on<ActivityFeaturedLoadRequested>(_onFeaturedLoadRequested);
    on<ActivitySearchRequested>(_onSearchRequested);
    on<ActivityFilterChanged>(_onFilterChanged);
    on<ActivityRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    ActivityLoadRequested event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    
    try {
      final activities = await _activityRepository.getActivities(
        page: event.page,
        limit: event.limit,
        category: event.category,
        search: event.search,
        sortBy: event.sortBy,
      );
      
      emit(ActivityLoaded(
        activities: activities,
        hasReachedMax: activities.length < event.limit,
      ));
    } catch (e) {
      emit(ActivityError(message: e.toString()));
    }
  }

  Future<void> _onFeaturedLoadRequested(
    ActivityFeaturedLoadRequested event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    
    try {
      final featuredActivities = await _activityRepository.getFeaturedActivities();
      
      emit(ActivityFeaturedLoaded(activities: featuredActivities));
    } catch (e) {
      emit(ActivityError(message: e.toString()));
    }
  }

  Future<void> _onSearchRequested(
    ActivitySearchRequested event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    
    try {
      final activities = await _activityRepository.getActivities(
        search: event.query,
        category: event.category,
        sortBy: event.sortBy,
      );
      
      emit(ActivityLoaded(
        activities: activities,
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(ActivityError(message: e.toString()));
    }
  }

  Future<void> _onFilterChanged(
    ActivityFilterChanged event,
    Emitter<ActivityState> emit,
  ) async {
    emit(ActivityLoading());
    
    try {
      final activities = await _activityRepository.getActivities(
        category: event.category,
        search: event.search,
        sortBy: event.sortBy,
      );
      
      emit(ActivityLoaded(
        activities: activities,
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(ActivityError(message: e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    ActivityRefreshRequested event,
    Emitter<ActivityState> emit,
  ) async {
    try {
      final activities = await _activityRepository.getActivities(
        category: event.category,
        search: event.search,
        sortBy: event.sortBy,
      );
      
      emit(ActivityLoaded(
        activities: activities,
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(ActivityError(message: e.toString()));
    }
  }
}