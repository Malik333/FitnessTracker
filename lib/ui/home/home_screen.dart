import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/bloc/activities/activities_bloc.dart';
import 'package:fitness_tracker/bloc/activities/activities_state.dart';
import 'package:fitness_tracker/data/enum/activitiy_type.dart';
import 'package:fitness_tracker/data/model/activity_model.dart';
import 'package:fitness_tracker/data/model/user_goals_model.dart';
import 'package:fitness_tracker/ui/bottom_modal/add_activity_modal.dart';
import 'package:fitness_tracker/ui/bottom_modal/filters_activity_modal.dart';
import 'package:fitness_tracker/ui/bottom_modal/user_goals_activity_modal.dart';
import 'package:fitness_tracker/ui/home/activitiy_item.dart';
import 'package:fitness_tracker/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/activities/activities_event.dart';
import '../../data/model/filter_activity_model.dart';
import '../../data/remote/shared_preferences_service.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "home_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ActivitiesBloc _bloc;
  late final UserGoalsModel? goalsModel;

  DateTime? filterSelectedDate;
  ActivityType? filterSelectedType;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var pref = await SharedPreferencesService.getInstance();
    goalsModel = pref.getData(Constants.USER_GOAL_KEY);

    if (mounted) {
      _bloc = BlocProvider.of<ActivitiesBloc>(context);
      _bloc.add(FetchActivitiesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return UserGoalsActivityModal();
                  },
                ).then((value) {
                  _bloc.add(FetchActivitiesEvent());
                });
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return AddNewActivityModal();
              },
            ).then((value) {
              _bloc.add(FetchActivitiesEvent());
            });
          },
          backgroundColor: AppColor.primary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              child: TextField(
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    _bloc.add(FetchActivitiesSearchEvent(text));
                  } else {
                    _bloc.add(FetchActivitiesEvent());
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    hintText: 'Search activities...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_alt),
                      onPressed: () {
                        showModalBottomSheet<FilterActivityModel>(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return FiltersActivityModal(
                              selectedDate: filterSelectedDate,
                              selectedType: filterSelectedType,
                            );
                          },
                        ).then<FilterActivityModel?>((value) {
                          if (value != null) {
                            filterSelectedDate = value.date?.toDate();
                            filterSelectedType = value.type;
                            _bloc.add(FetchActivitiesFilterEvent(value));
                          }
                        });
                      },
                    )),
              ),
            ),
            BlocConsumer<ActivitiesBloc, ActivitiesState>(
              listener: (context, state) {},
              builder: (context, state) {
                List<ActivityModel>? dataModel;
                if (state is ActivitiesError) {
                  return Center(
                    child: Text(state.error),
                  );
                }

                if (state is ActivitiesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is ActivitiesLoaded) {
                  dataModel = state.activitiesModel!;
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: dataModel?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ActivityItem(
                        title: dataModel?[index].title ?? '',
                        description: dataModel?[index].description ?? '',
                        type: dataModel?[index].type ?? ActivityType.OTHER,
                        createdAt:
                            dataModel?[index].createdAt ?? Timestamp.now(),
                        duration: dataModel?[index].duration ?? '',
                        docId: dataModel?[index].documentId ?? '',
                        userGoalsModel: goalsModel,
                      );
                    },
                  ),
                );
              },
            )
          ],
        ));
  }
}
