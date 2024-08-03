import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/bloc/activities/activities_bloc.dart';
import 'package:fitness_tracker/bloc/activities/activities_event.dart';
import 'package:fitness_tracker/data/enum/activitiy_type.dart';
import 'package:fitness_tracker/data/model/activity_model.dart';
import 'package:fitness_tracker/data/model/filter_activity_model.dart';
import 'package:fitness_tracker/data/model/user_goals_model.dart';
import 'package:fitness_tracker/data/remote/shared_preferences_service.dart';
import 'package:fitness_tracker/ui/widgets/counter_widget.dart';
import 'package:fitness_tracker/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../../bloc/activities/activities_state.dart';

class UserGoalsActivityModal extends StatefulWidget {
  const UserGoalsActivityModal({super.key});

  @override
  State<UserGoalsActivityModal> createState() => _UserGoalsActivityModalState();
}

class _UserGoalsActivityModalState extends State<UserGoalsActivityModal> {
  ///Controllers
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  ///FormBuilder
  final _formKeyDuration = GlobalKey<FormBuilderState>();
  final _formKeyQuantity = GlobalKey<FormBuilderState>();

  bool isEmpty = true;
  bool isSaving = false;

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return  buildPage(context);
  }

  Widget buildPage(BuildContext context) {

    return Container(
        color: Colors.white,
        height: MediaQuery
            .sizeOf(context)
            .height * 0.8,
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
                      child: Text('Goals activity'.toUpperCase(),
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
                      const Text("Please enter the duration of your exercise in minutes and specify the quantity for one day", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),),
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: FormBuilder(
                              key: _formKeyDuration,
                              child: TextFormField(
                                controller: _durationController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  isEmpty = false;
                                  if (value!.isEmpty) {
                                    isEmpty = true;
                                    return 'Enter duration';
                                  }

                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter duration',
                                ),
                              ),
                            ),
                          ),
                          Expanded(flex: 4, child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CounterView(initNumber: 1, counterCallback: (counter) => quantity = counter, increaseCallback: () {}, decreaseCallback: () {}, minNumber: 1),
                          )),
                        ],
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
                          onPressed: isSaving ? null : () async {
                            setState(() {
                              isSaving = true;
                            });

                            UserGoalsModel goalsModel = UserGoalsModel(minutes: int.parse(_durationController.text), quantity: quantity);

                           var pref = await SharedPreferencesService.getInstance();
                           pref.saveData(Constants.USER_GOAL_KEY, goalsModel);
                          },
                          child: Text('Save'.toUpperCase(),
                            style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: MediaQuery
                          .of(context)
                          .viewInsets
                          .bottom))
                    ],
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}
