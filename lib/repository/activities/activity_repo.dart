import 'dart:async';

import '../../data/model/activity_model.dart';
import '../../data/remote/abstract_api_service.dart';
import '../../data/remote/api_endpoints.dart';
import '../../data/remote/api_service.dart';

class ActivitiesRepo {
  final AbstractApiService _apiService = ApiService();

  FutureOr<List<ActivityModel>?> getActivities() async {
    try {
      List<ActivityModel> response = await _apiService.getActivities(ApiEndpoints.activityCollectionName);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  //FutureOr<ActivityModel> getActivity() async {}
}