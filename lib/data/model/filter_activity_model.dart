import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/data/enum/activitiy_type.dart';

class FilterActivityModel{
  ActivityType? type;
  Timestamp? date;

  FilterActivityModel({this.type, this.date});
}