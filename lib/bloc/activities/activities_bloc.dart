import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_tracker/repository/activities/activity_repo.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../data/remote/api_exception.dart';
import 'activities_event.dart';
import 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final _activitiesRepo = ActivitiesRepo();

  ActivitiesBloc() : super(ActivitiesInitial()) {
    on<FetchActivitiesEvent>(loadActivities);
    on<CreateActivityEvent>(createNewActivity);
    on<EditActivityEvent>(editActivity);
    on<DeleteActivityEvent>(deleteActivity);
    on<FetchActivityEvent>(loadActivityData);
    on<FetchActivitiesSearchEvent>(loadSearchActivities, transformer: debounce(const Duration(milliseconds: 600)));
    on<FetchActivitiesFilterEvent>(filterActivity);
  }

  loadActivities(FetchActivitiesEvent event, Emitter<ActivitiesState> emit) async{
    emit(ActivitiesLoading());
    try {
      var data = await _activitiesRepo.getActivities();
      emit(ActivitiesLoaded(data));
    }catch (e) {
      print(e);
      emit(ActivitiesError(e.toString()));
    }
  }

  loadSearchActivities(FetchActivitiesSearchEvent event, Emitter<ActivitiesState> emit) async{
    emit(ActivitiesLoading());
    try {
      var data = await _activitiesRepo.searchActivities(event.query);
      emit(ActivitiesLoaded(data));
    }catch (e) {
      print(e);
      emit(ActivitiesError(e.toString()));
    }
  }

  loadActivityData(FetchActivityEvent event, Emitter<ActivitiesState> emit) async{
    try {
      var data = await _activitiesRepo.getActivity(event.id);
      emit(ActivityLoaded(data));
    }catch (e) {
      print(e);
      emit(ActivitiesError(e.toString()));
    }
  }

  createNewActivity(CreateActivityEvent event, Emitter<ActivitiesState> emit) async{
    emit(CreatingActivity());
    try {
      await _activitiesRepo.createActivity(event.body);
      emit(CreatedActivity());
    }catch (e) {
      print(e);
      emit(ActivitiesError(e.toString()));
    }
  }

  deleteActivity(DeleteActivityEvent event, Emitter<ActivitiesState> emit) async{
    try {
      await _activitiesRepo.deleteActivity(event.id);
      add(FetchActivitiesEvent());
    }catch (e) {
      print(e);
      emit(ActivitiesError(e.toString()));
    }
  }

  editActivity(EditActivityEvent event, Emitter<ActivitiesState> emit) async{
    try {
      await _activitiesRepo.editActivity(event.id, event.body);
      emit(CreatedActivity());
    }catch (e) {
      print(e);
      emit(ActivitiesError(e.toString()));
    }
  }

  filterActivity(FetchActivitiesFilterEvent event, Emitter<ActivitiesState> emit) async{
    try {
      var data = await _activitiesRepo.filtersActivities(event.filterActivityModel);
      emit(ActivitiesLoaded(data));
    }catch (e) {
      print(e);
      emit(ActivitiesError(e.toString()));
    }
  }

  //Debounce query requests
  EventTransformer<FetchActivitiesSearchEvent> debounce<E>(Duration duration) {
    return (events, mapper) {
      return events.debounce(duration).switchMap(mapper);
    };
  }
}
