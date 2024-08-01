import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/data/model/activity_model.dart';
import 'package:fitness_tracker/data/remote/api_endpoints.dart';
import 'package:fitness_tracker/data/remote/api_exception.dart';

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
