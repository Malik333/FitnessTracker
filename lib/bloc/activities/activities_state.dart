

import 'package:fitness_tracker/data/model/activity_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ActivitiesState {
}
class ActivitiesInitial extends ActivitiesState {}
class ActivitiesLoading extends ActivitiesState {}
class ActivitiesLoaded extends ActivitiesState {
  final List<ActivityModel>? activitiesModel;
  ActivitiesLoaded(this.activitiesModel);
}

class ActivityLoaded extends ActivitiesState {
  final ActivityModel activityModel;
  ActivityLoaded(this.activityModel);
}

class CreatingActivity extends ActivitiesState {}
class CreatedActivity extends ActivitiesState {}

class ActivitiesError extends ActivitiesState {
  final String error;
  ActivitiesError(this.error);
}
