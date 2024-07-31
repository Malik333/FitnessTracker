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
      return data.docs.map((e) => ActivityModel.fromJson(e.data())).toList();
    } on FirebaseException catch (ex) {
      throw FetchDataException(ex.message);
    }



  }

  @override
  Future<ActivityModel> getActivity(String collectionName, String documentId) {
    // TODO: implement getActivity
    throw UnimplementedError();
  }

}
