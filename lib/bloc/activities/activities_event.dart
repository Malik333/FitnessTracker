import 'package:fitness_tracker/data/model/activity_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ActivitiesEvent {}

class FetchActivitiesEvent extends ActivitiesEvent {}

class CreateActivityEvent extends ActivitiesEvent {
  final ActivityModel body;

  CreateActivityEvent(this.body);
}

class FetchActivitiesSearchEvent extends ActivitiesEvent {
  final String query;

  FetchActivitiesSearchEvent(this.query);
}
