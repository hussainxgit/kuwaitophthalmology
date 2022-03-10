import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

import '/models/doctor_user.dart';
import '/models/operation.dart';
import '/services/api_services.dart';
import '/services/data_services.dart';
import '/widgets/custom_app_bar.dart';

class AddSurgicalLog extends StatefulWidget {
  const AddSurgicalLog({Key? key}) : super(key: key);

  @override
  State<AddSurgicalLog> createState() => _AddSurgicalLogState();
}

class _AddSurgicalLogState extends State<AddSurgicalLog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fileNumberController = TextEditingController();
  TextEditingController procedureController = TextEditingController();
  TextEditingController leftEyeController = TextEditingController();
  TextEditingController rightEyeController = TextEditingController();
  TextEditingController postOpLtController = TextEditingController();
  TextEditingController postOpRtController = TextEditingController();
  TextEditingController complicationsController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final DataServices _dataServices = Get.find();
  final ApiServices _apiServices = ApiServices();

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
            icon: const Icon(Icons.save),
            tooltip: 'Send',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Operation operation = Operation(
                    patientName: nameController.value.text,
                    patientFileNumber: fileNumberController.value.text,
                    procedure: procedureController.value.text,
                    leftEye: leftEyeController.value.text,
                    rightEye: rightEyeController.value.text,
                    postOpLeftEye: postOpLtController.value.text,
                    postOpRightEye: postOpRtController.value.text,
                    complications: complicationsController.value.text,
                    operationDate: selectedDate,
                    doctorUser: DoctorUser(
                        name: 'Hussain SK',
                        email: 'robinx5.q8@gmail.com',
                        phone: '62228494'));
                _apiServices
                    .addOperationLog(operation)
                    .whenComplete(
                        () => _dataServices.doctorOperations.add(operation))
                    .whenComplete(() => Get.back());
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
                      height: 8.0,
                    ),
                    const Text('Note. please type full name of the patient'),
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
                    const Text('Note. You can add post OP later'),
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
                        const SizedBox(
                          width: 16.0,
                        ),
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
                            controller: postOpLtController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Left eye'),
                                prefixText: '20 / '),
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dateCtl.dispose();
    nameController.dispose();
    fileNumberController.dispose();
    procedureController.dispose();
    leftEyeController.dispose();
    rightEyeController.dispose();
    postOpLtController.dispose();
    postOpRtController.dispose();
    complicationsController.dispose();
  }
}
