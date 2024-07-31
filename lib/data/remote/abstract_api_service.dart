import 'package:fitness_tracker/data/model/activity_model.dart';

abstract class AbstractApiService {

  Future<List<ActivityModel>> getActivities(String collectionName);
  Future<ActivityModel> getActivity(String collectionName, String documentId);

}