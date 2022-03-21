import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

import '/models/operation.dart';
import '/services/api_services.dart';
import '/services/data_services.dart';
import '/views/home_view.dart';
import '/widgets/custom_app_bar.dart';

class EditSurgicalLog extends StatefulWidget {
  final Operation operation;

  const EditSurgicalLog({Key? key, required this.operation}) : super(key: key);

  @override
  State<EditSurgicalLog> createState() => _EditSurgicalLogState();
}

class _EditSurgicalLogState extends State<EditSurgicalLog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DataServices _dataServices = Get.find();
  DateTime selectedDate = DateTime.now();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fileNumberController = TextEditingController();
  TextEditingController procedureController = TextEditingController();
  TextEditingController leftEyeController = TextEditingController();
  TextEditingController rightEyeController = TextEditingController();
  TextEditingController postOpLtController = TextEditingController();
  TextEditingController postOpRtController = TextEditingController();
  TextEditingController complicationsController = TextEditingController();

  Future<DateTime?> showDate(BuildContext context) async {
    return await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(1998),
            lastDate: DateTime(2100)) ??
        selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actionList: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _dataServices
                    .editOperation(Operation(
                        uid: widget.operation.uid,
                        patientName: nameController.value.text,
                        patientFileNumber: fileNumberController.value.text,
                        procedure: procedureController.value.text,
                        leftEye: leftEyeController.value.text,
                        rightEye: rightEyeController.value.text,
                        postOpLeftEye: postOpLtController.value.text,
                        postOpRightEye: postOpRtController.value.text,
                        complications: complicationsController.value.text,
                        operationDate: selectedDate,
                        doctorUser: _dataServices.currentUser.value))
                    .whenComplete(() => Get.to(() => const HomeView()));
              }
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
                      'Patient',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: fileNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'File number is required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'File number',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Patient name is required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                      ),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    const Text(
                      'Procedure',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8.0,
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
                        labelText: "Date of Operation",
                      ),
                      onTap: () async {
                        selectedDate = await showDate(context) ?? selectedDate;
                        dateCtl.text =
                            DateFormat("yyyy MMMM d").format(selectedDate);
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: procedureController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Procedure is required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Procedure'),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: rightEyeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Right eye vision is required';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Right eye'),
                                prefixText: '20 / '),
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: leftEyeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Left eye vision is required';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Left eye'),
                                prefixText: '20 / '),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    const Text(
                      'Post OP',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text('Note. You can add post OP later'),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: postOpRtController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Right eye'),
                                prefixText: '20 / '),
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: postOpLtController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Left eye'),
                                prefixText: '20 / '),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: complicationsController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Complications',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 7,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = widget.operation.operationDate!;
    dateCtl.text = widget.operation.operationDate.toString();
    nameController.text = widget.operation.patientName!;
    fileNumberController.text = widget.operation.patientFileNumber!;
    procedureController.text = widget.operation.procedure!;
    leftEyeController.text = widget.operation.leftEye!;
    rightEyeController.text = widget.operation.rightEye!;
    postOpRtController.text = widget.operation.postOpRightEye!;
    postOpLtController.text = widget.operation.postOpLeftEye!;
    complicationsController.text = widget.operation.complications!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dateCtl.dispose();
    nameController.dispose();
    fileNumberController.dispose();
    procedureController.dispose();
    leftEyeController.dispose();
    rightEyeController.dispose();
    postOpRtController.dispose();
    complicationsController.dispose();
  }
}
