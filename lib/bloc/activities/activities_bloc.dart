import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_tracker/repository/activities/activity_repo.dart';

import '../../data/remote/api_exception.dart';
import 'activities_event.dart';
import 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final _activitiesRepo = ActivitiesRepo();

  ActivitiesBloc() : super(ActivitiesInitial()) {
    on<FetchActivitiesEvent>(loadActivities);

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
}
