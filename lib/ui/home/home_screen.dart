import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/bloc/activities/activities_bloc.dart';
import 'package:fitness_tracker/bloc/activities/activities_state.dart';
import 'package:fitness_tracker/data/enum/activitiy_type.dart';
import 'package:fitness_tracker/data/model/activity_model.dart';
import 'package:fitness_tracker/ui/bottom_modal/add_activity_modal.dart';
import 'package:fitness_tracker/ui/home/activitiy_item.dart';
import 'package:fitness_tracker/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/activities/activities_event.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "home_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ActivitiesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ActivitiesBloc>(context);
    _bloc.add(FetchActivitiesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home', style: TextStyle(color: Colors.white),),
          actions: [
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
            );
          },
          backgroundColor: AppColor.primary,
          child: const Icon(Icons.add, color: Colors.white,),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              child: TextField(
                onChanged: (text) {
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Search activities...',
                ),
              ),
            ),
            BlocConsumer<ActivitiesBloc, ActivitiesState>(listener: (context, state){

            },
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
                      createdAt: dataModel?[index].createdAt ?? Timestamp.now(),
                      duration: dataModel?[index].duration ?? '',
                    );
                  },
                ),
              );
            },)
          ],
        ));
  }
}
