import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:kuwaitophthalmology/models/leave.dart';

import '/services/data_services.dart';
import '/widgets/custom_app_bar.dart';

class CreateLeave extends StatefulWidget {
  const CreateLeave({Key? key}) : super(key: key);

  @override
  State<CreateLeave> createState() => _CreateLeaveState();
}

class _CreateLeaveState extends State<CreateLeave> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController dateCt2 = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  final DataServices _dataServices = Get.find();

  Future<DateTime?> showDate(BuildContext context, String i) async {
    if (i == 'startDate') {
      return await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(1998),
              lastDate: DateTime(2100)) ??
          selectedDate;
    } else {
      return await showDatePicker(
              context: context,
              initialDate: selectedDate2,
              firstDate: DateTime(1998),
              lastDate: DateTime(2100)) ??
          selectedDate2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actionList: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Send',
            onPressed: () {
              _dataServices.createLeave(Leave(
                  user: _dataServices.currentUser.value,
                  approvals: [],
                  startDate: selectedDate,
                  endDate: selectedDate2,
                  uid: ''));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Leave start in',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date is required';
                        }
                        return null;
                      },
                      readOnly: true,
                      controller: dateCtl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Start Date",
                      ),
                      onTap: () async {
                        selectedDate = await showDate(context, 'startDate') ??
                            selectedDate;
                        dateCtl.text =
                            DateFormat("yyyy MMMM d").format(selectedDate);
                      },
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    const Text(
                      'End in',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date is required';
                        }
                        return null;
                      },
                      readOnly: true,
                      controller: dateCt2,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "End Date",
                      ),
                      onTap: () async {
                        selectedDate2 =
                            await showDate(context, 'endDate') ?? selectedDate2;
                        dateCt2.text =
                            DateFormat("yyyy MMMM d").format(selectedDate2);
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dateCtl.dispose();
    dateCt2.dispose();
  }
}
