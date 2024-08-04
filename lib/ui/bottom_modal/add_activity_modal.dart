import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/bloc/activities/activities_bloc.dart';
import 'package:fitness_tracker/bloc/activities/activities_event.dart';
import 'package:fitness_tracker/data/enum/activitiy_type.dart';
import 'package:fitness_tracker/data/model/activity_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../../bloc/activities/activities_state.dart';

class AddNewActivityModal extends StatefulWidget {
  final String? docId;
  final bool isEditing;


  const AddNewActivityModal({super.key, this.docId, this.isEditing = false});

  @override
  State<AddNewActivityModal> createState() => _AddNewActivityModalState();
}

class _AddNewActivityModalState extends State<AddNewActivityModal> {
  ///Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  ///FormBuilder
  final _formKeyTitle = GlobalKey<FormBuilderState>();
  final _formKeyDesc = GlobalKey<FormBuilderState>();
  final _formKeyDate = GlobalKey<FormBuilderState>();
  final _formKeyTime = GlobalKey<FormBuilderState>();
  final _formKeyDuration = GlobalKey<FormBuilderState>();

  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2045);

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now();

  bool isEmpty = true;
  bool isCreating = false;
  bool isInitialized = false;

  ActivityType activityType = ActivityType.RUN;

  late ActivitiesBloc activityBloc;

  void displayData(ActivityModel model) {
    if (isInitialized) return;

    _titleController.text = model.title!;
    _descController.text = model.description!;
    _durationController.text = model.duration!;
    activityType = model.type!;

    var dateTime = model.createdAt!.toDate();
    _dateController.text = dateTime.toLocal().toString().split(" ")[0];
    _timeController.text = '${dateTime.hour}:${dateTime.minute}';

    selected = dateTime;
    timeOfDay = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

    isInitialized = true;
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivitiesBloc>(
        create: (context) => ActivitiesBloc(),
        child: Builder(builder: (context) => buildPage(context),)
    );
  }

  Widget buildPage(BuildContext context) {

    activityBloc = BlocProvider.of<ActivitiesBloc>(context);

    if (widget.isEditing && !isInitialized) {
      activityBloc.add(FetchActivityEvent(widget.docId!));
    }

    return Container(
      color: Colors.white,
      height: MediaQuery
          .sizeOf(context)
          .height * 0.8,
      child: BlocConsumer<ActivitiesBloc, ActivitiesState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {

          if (state is CreatingActivity) {
            isCreating = true;
          }

          if (state is ActivitiesError) {
            isCreating = false;
          }

          if (state is CreatedActivity) {
            WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          }

          if (state is ActivityLoaded) {
            displayData(state.activityModel);
          }

          return Column(
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
                          widget.isEditing ? 'Update activity'.toUpperCase() : 'Add new activity'.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
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
                          key: _formKeyTitle,
                          child: TextFormField(
                            controller: _titleController,
                            validator: (value) {
                              isEmpty = false;
                              if (value!.isEmpty) {
                                isEmpty = true;
                                return 'Please enter a title';
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a title',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FormBuilder(
                          key: _formKeyDesc,
                          child: TextFormField(
                            controller: _descController,
                            validator: (value) {
                              isEmpty = false;
                              if (value!.isEmpty) {
                                isEmpty = true;
                                return 'Please enter a description';
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a description',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8,),
                        FormField(builder: (state) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
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
                                          child: Text(typeName(value),
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
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: FormBuilder(
                                key: _formKeyDate,
                                child: TextFormField(
                                  controller: _dateController,
                                  readOnly: true,
                                  validator: (value) {
                                    isEmpty = false;
                                    if (value!.isEmpty) {
                                      isEmpty = true;
                                      return 'Please pick a date';
                                    }

                                    return null;
                                  },
                                  onTap: () => displayDatePicker(context),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Pick date',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              flex: 4,
                              child: FormBuilder(
                                key: _formKeyTime,
                                child: TextFormField(
                                  controller: _timeController,
                                  readOnly: true,
                                  validator: (value) {
                                    isEmpty = false;
                                    if (value!.isEmpty) {
                                      isEmpty = true;
                                      return 'Please enter a time';
                                    }

                                    return null;
                                  },
                                  onTap: () => displayTimePicker(context),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Pick a time',
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FormBuilder(
                          key: _formKeyDuration,
                          child: TextFormField(
                            controller: _durationController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              isEmpty = false;
                              if (value!.isEmpty) {
                                isEmpty = true;
                                return 'Please enter a duration';
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter duration of your activity in minutes',
                            ),
                          ),
                        ),
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
                            onPressed: isCreating ? null : () {
                              _formKeyTitle.currentState!.validate();
                              _formKeyDesc.currentState!.validate();
                              _formKeyDate.currentState!.validate();
                              _formKeyTime.currentState!.validate();
                              _formKeyDuration.currentState!.validate();

                              if (!isEmpty) {
                                DateFormat inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
                                var dateTimeSelected = "${_dateController.text} ${_timeController.text}:00";
                                var date = inputFormat.parse(dateTimeSelected);
                                var body = ActivityModel(
                                  title: _titleController.text,
                                  description: _descController.text,
                                  createdAt: Timestamp.fromDate(date),
                                  type: activityType,
                                  duration: _durationController.text
                                );

                                if (widget.isEditing) {
                                  activityBloc.add(EditActivityEvent(widget.docId!, body));
                                } else {
                                  activityBloc.add(CreateActivityEvent(body));
                                }
                              }
                            },
                            child: Text(
                              widget.isEditing ? 'Save'.toUpperCase() : 'Create'.toUpperCase(),
                              style:
                              const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: initial,
      lastDate: last,
    );

    if (date != null) {
      setState(() {
        _dateController.text = date.toLocal().toString().split(" ")[0];
      });
    }
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        _timeController.text = "${time.hour}:${time.minute}";
      });
    }
  }
}
