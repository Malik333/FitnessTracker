import 'package:fitness_tracker/data/model/activity_model.dart';
import 'package:fitness_tracker/data/model/filter_activity_model.dart';
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

class FetchActivitiesFilterEvent extends ActivitiesEvent {
  final FilterActivityModel filterActivityModel;

  FetchActivitiesFilterEvent(this.filterActivityModel);
}

class FetchActivityEvent extends ActivitiesEvent {
  final String id;

  FetchActivityEvent(this.id);
}

class EditActivityEvent extends ActivitiesEvent {
  final String id;
  final ActivityModel body;

  EditActivityEvent(this.id, this.body);
}

class DeleteActivityEvent extends ActivitiesEvent {
  final String id;

  DeleteActivityEvent(this.id);
}

