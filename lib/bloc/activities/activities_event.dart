import 'package:flutter/material.dart';

@immutable
abstract class ActivitiesEvent {}


class FetchActivitiesEvent extends ActivitiesEvent {}


class FetchActivitiesSearchEvent extends ActivitiesEvent {
  final String query;
  FetchActivitiesSearchEvent(this.query);
}