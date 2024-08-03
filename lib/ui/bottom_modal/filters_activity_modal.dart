import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/bloc/activities/activities_bloc.dart';
import 'package:fitness_tracker/bloc/activities/activities_event.dart';
import 'package:fitness_tracker/data/enum/activitiy_type.dart';
import 'package:fitness_tracker/data/model/activity_model.dart';
import 'package:fitness_tracker/data/model/filter_activity_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../../bloc/activities/activities_state.dart';

class FiltersActivityModal extends StatefulWidget {
  final DateTime? selectedDate;
  final ActivityType? selectedType;
  const FiltersActivityModal({super.key, this.selectedDate, this.selectedType});

  @override
  State<FiltersActivityModal> createState() => _FiltersActivityModalState();
}

class _FiltersActivityModalState extends State<FiltersActivityModal> {
  ///Controllers
  final TextEditingController _dateController = TextEditingController();

  ///FormBuilder
  final _formKeyDate = GlobalKey<FormBuilderState>();

  ///Date
  DateTime? selected;
  DateTime initial = DateTime.now();
  DateTime firstDate = DateTime(2000);
  DateTime last = DateTime(2045);

  bool isEmpty = true;

  ActivityType activityType = ActivityType.RUN;

  @override
  void initState() {
    super.initState();

    if (widget.selectedDate != null) {
      initial = widget.selectedDate!;
      selected = widget.selectedDate;
      _dateController.text = widget.selectedDate!.toLocal().toString().split(" ")[0];
    }

    if (widget.selectedType != null) {
      activityType = widget.selectedType!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }

  Widget buildPage(BuildContext context) {
    return Container(
        color: Colors.white,
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade400,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Filters activity'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          var filters = FilterActivityModel();

                          Navigator.of(context).pop(filters);
                        },
                        child: const Text(
                          "Clear all",
                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      FormBuilder(
                        key: _formKeyDate,
                        child: TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          validator: (value) {
                            isEmpty = false;
                            if (value!.isEmpty) {
                              isEmpty = true;
                              return 'Select date';
                            }

                            return null;
                          },
                          onTap: () => displayDatePicker(context),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Select date',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FormField(builder: (state) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all()),
                          width: double.infinity,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<ActivityType>(
                              value: activityType,
                              icon: const Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 10,
                                ),
                              ),
                              onChanged: (ActivityType? newValue) {
                                setState(() {
                                  activityType = newValue!;
                                });
                              },
                              items: ActivityType.values
                                  .map<DropdownMenuItem<ActivityType>>(
                                      (ActivityType value) {
                                return DropdownMenuItem<ActivityType>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      typeName(value),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Timestamp? selectedDate;

                            if (selected != null) {
                              selectedDate = Timestamp.fromDate(selected!);
                            }

                            var filters = FilterActivityModel(
                                date: selectedDate, type: activityType);

                            Navigator.of(context).pop(filters);
                          },
                          child: Text(
                            'Filter'.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom))
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: last,
    );

    if (date != null) {
      setState(() {
        selected = date;
        _dateController.text = date.toLocal().toString().split(" ")[0];
      });
    }
  }
}
