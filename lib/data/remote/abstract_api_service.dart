import 'package:fitness_tracker/data/model/activity_model.dart';

abstract class AbstractApiService {

  Future<List<ActivityModel>> getActivities(String collectionName);
  Future<ActivityModel> getActivity(String collectionName, String documentId);
  Future<void> createActivity(String collectionName, ActivityModel bodyModel);
  Future<void> editActivity(String collectionName, String docId, ActivityModel bodyModel);
  Future<void> deleteActivity(String collectionName, String docId);

}