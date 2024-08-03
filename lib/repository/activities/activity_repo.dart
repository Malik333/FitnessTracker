import 'dart:async';

import 'package:fitness_tracker/data/model/filter_activity_model.dart';

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

  FutureOr<ActivityModel> getActivity(String documentId) async {
    try {
      ActivityModel response = await _apiService.getActivity(ApiEndpoints.activityCollectionName, documentId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<List<ActivityModel>?> searchActivities(String query) async {
    try {
      List<ActivityModel> response = await _apiService.searchActivities(ApiEndpoints.activityCollectionName, query);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<List<ActivityModel>?> filtersActivities(FilterActivityModel filterActivityModel) async {
    try {
      List<ActivityModel> response = await _apiService.filtersActivities(ApiEndpoints.activityCollectionName, filterActivityModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> createActivity(ActivityModel model) async {
    try {
      await _apiService.createActivity(ApiEndpoints.activityCollectionName, model);
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> deleteActivity(String documentId) async {
    try {
      await _apiService.deleteActivity(ApiEndpoints.activityCollectionName, documentId);
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> editActivity(String documentId, ActivityModel model) async {
    try {
      await _apiService.editActivity(ApiEndpoints.activityCollectionName, documentId, model);
    } catch (e) {
      rethrow;
    }
  }

}