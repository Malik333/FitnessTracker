import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddNewActivityModal extends StatefulWidget {
  @override
  State<AddNewActivityModal> createState() => _AddNewActivityModalState();
}

class _AddNewActivityModalState extends State<AddNewActivityModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade400,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () {

                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Add new activity'.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (text) {
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a name',
                    ),
                  ),
                  const SizedBox(height: 5,),
                  TextField(
                    onChanged: (text) {
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a description',
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}