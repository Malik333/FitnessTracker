import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/data/enum/activitiy_type.dart';
import 'package:fitness_tracker/data/model/activity_model.dart';
import 'package:fitness_tracker/data/remote/api_endpoints.dart';
import 'package:fitness_tracker/data/remote/api_exception.dart';

import '../model/filter_activity_model.dart';
import 'abstract_api_service.dart';

class ApiService implements AbstractApiService {

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<List<ActivityModel>> getActivities(String collectionName) async {
    try {
      var activities = db.collection(collectionName);
      var data = await activities.get();
      return data.docs.map((e) {
        return ActivityModel.fromJson(e.data(), e.id);
      }).toList();
    } on FirebaseException catch (ex) {
      throw FetchDataException(ex.message);
    }
  }

  @override
  Future<ActivityModel> getActivity(String collectionName, String documentId) async {
    try {
      var activity = db.collection(collectionName).doc(documentId);
      var data = await activity.get();

      return ActivityModel.fromJson(data.data()!, data.id);
    } on FirebaseException catch (ex) {
      throw FetchDataException(ex.message);
    }
  }
  
 @override
  Future<List<ActivityModel>> searchActivities(String collectionName, String text) async {
   try {
     var activities = db.collection(collectionName);
     var data = await activities.where("title", isGreaterThanOrEqualTo: text, isLessThan: text.isEmpty ? null : text.substring(0, text.length - 1) + String.fromCharCode(text.codeUnitAt(text.length - 1) + 1))
         .where("description", isGreaterThanOrEqualTo: text, isLessThan: text.isEmpty ? null : text.substring(0, text.length - 1) + String.fromCharCode(text.codeUnitAt(text.length - 1) + 1)).get();
     return data.docs.map((e) {
       return ActivityModel.fromJson(e.data(), e.id);
     }).toList();
   } on FirebaseException catch (ex) {
     throw FetchDataException(ex.message);
   }
  }

  @override
  Future<List<ActivityModel>> filtersActivities(String collectionName, FilterActivityModel model) async {
    try {
      var activities = db.collection(collectionName);
      QuerySnapshot<Map<String, dynamic>>? query;

      if (model.date != null && model.type != null) {
        query = await activities.where("created_at", isEqualTo: model.date).where("type", isEqualTo: typeName(model.type!)).get();
      } else if (model.type == null && model.date != null) {
        query = await activities.where("created_at", isEqualTo: model.date).get();
      } else if (model.type != null && model.date == null) {
        query = await activities.where("type", isEqualTo: typeName(model.type!)).get();
      }

      return query!.docs.map((e) {
        var data = e.data();
        return ActivityModel.fromJson(data, e.id);
      }).toList();
    } on FirebaseException catch (ex) {
      throw FetchDataException(ex.message);
    }
  }

  @override
  Future<void> createActivity(String collectionName, ActivityModel bodyModel) async{
    try {
      var activity = db.collection(collectionName);
      await activity.add(bodyModel.toJson());
    } on FirebaseException catch (ex) {
      throw FetchDataException(ex.message);
    }
  }

  @override
  Future<void> deleteActivity(String collectionName, String docId) async {
    try {
      var activity = db.collection(collectionName).doc(docId);
      await activity.delete();
    } on FirebaseException catch (ex) {
      throw FetchDataException(ex.message);
    }
  }

  @override
  Future<void> editActivity(String collectionName, String docId, ActivityModel bodyModel) async {
    try {
      var activity = db.collection(collectionName).doc(docId);
      await activity.update(bodyModel.toJson());
    } on FirebaseException catch (ex) {
      throw FetchDataException(ex.message);
    }
  }

}
