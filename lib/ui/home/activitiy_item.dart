import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../data/enum/activitiy_type.dart';

class ActivityItem extends StatefulWidget {
  String? title;
  String? description;
  Timestamp? createdAt;
  ActivityType? type;
  String? duration;

  ActivityItem(
      {super.key, this.title, this.description, this.createdAt, this.type, this.duration});

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        margin:
        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
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
                        const Icon(Icons.access_time_outlined, size: 10,),
                        const SizedBox(width: 4,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat("dd.MM.yyyy hh:mm").format(widget.createdAt!.toDate()),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
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
                child: Column(
                  children: [
                    Text(
                      typeName(widget.type!),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      '${widget.duration ?? ' '} min',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
            )
          ],
        ));
  }
}