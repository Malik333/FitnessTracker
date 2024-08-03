import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/bloc/activities/activities_event.dart';
import 'package:fitness_tracker/data/model/user_goals_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/activities/activities_bloc.dart';
import '../../data/enum/activitiy_type.dart';
import '../bottom_modal/add_activity_modal.dart';

class ActivityItem extends StatefulWidget {
  final String? title;
  final String? description;
  final Timestamp? createdAt;
  final ActivityType? type;
  final String? duration;
  final String? docId;
  final UserGoalsModel? userGoalsModel;

  const ActivityItem(
      {super.key,
      this.title,
      this.description,
      this.createdAt,
      this.type,
      this.duration,
      this.docId,
      this.userGoalsModel});

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  late final ActivitiesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ActivitiesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title ?? '',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_time_outlined,
                                size: 10,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat("dd.MM.yyyy hh:mm")
                                        .format(widget.createdAt!.toDate()),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.description!,
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              typeName(widget.type!),
                              style: TextStyle(
                                  color: getTextColor(),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              '${widget.duration ?? ' '} min',
                              style: TextStyle(
                                  color: getTextColor(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Icon(Icons.more_horiz_rounded),
                    onTapUp: (details) {
                      _showPopupMenu(context, details.globalPosition);
                    },
                  ),
                )
              ],
            )
          ],
        ));
  }

  Color getTextColor() {
    if (widget.userGoalsModel != null) {
      var duration = widget.userGoalsModel!.minutes!;
      var quantity = widget.userGoalsModel!.quantity!;

      var totalDuration = duration * quantity;

      if (int.parse(widget.duration!) > totalDuration) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }

    return Colors.black;
  }

  void _showPopupMenu(BuildContext context, Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromDirectional(
          textDirection: Directionality.of(context),
          start: left,
          top: top,
          end: left + 2,
          bottom: top + 2),
      items: [
        PopupMenuItem<String>(
          child: const Text('Edit'),
          value: 'Edit',
          onTap: () {
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
                return AddNewActivityModal(
                  docId: widget.docId,
                  isEditing: true,
                );
              },
            ).then((value) {
              _bloc.add(FetchActivitiesEvent());
            });
          },
        ),
        PopupMenuItem<String>(
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
          value: 'Delete',
          onTap: () {
            showAlertDialog(context);
          },
        ),
      ],
      elevation: 8.0,
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        _bloc.add(DeleteActivityEvent(widget.docId!));
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Delete",
        style: TextStyle(color: Colors.red),
      ),
      content: const Text("Are you sure you want to delete?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
