import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

import '/models/operation.dart';
import '/services/data_services.dart';
import '../views/operation_logs/edit_surgical_log.dart';

class OperativeLogsList extends StatefulWidget {
  final String userEmail;

  const OperativeLogsList({Key? key, required this.userEmail})
      : super(key: key);

  @override
  State<OperativeLogsList> createState() => _OperativeLogsListState();
}

class _OperativeLogsListState extends State<OperativeLogsList> {
  final DataServices _dataServices = Get.find();
  List<Operation> allOperation = [];
  Future<void>? _initData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData = _initAllOperationsData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initData,
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            {
              return const Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          case ConnectionState.done:
            {
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  itemCount: allOperation.length,
                  itemBuilder: (BuildContext context, int index) {
                    Operation operation = allOperation[index];
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.only(right: 12.0),
                        decoration: const BoxDecoration(
                            border: Border(right: BorderSide(width: 0.7))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateFormat('MMM').format(
                                DateTime(0, operation.operationDate!.month))),
                            Text(operation.operationDate!.day.toString()),
                          ],
                        ),
                      ),
                      title: Text(
                        operation.patientName!,
                        style: TextStyle(
                            color: operation.complications!.isEmpty
                                ? null
                                : Colors.redAccent),
                      ),
                      subtitle: Text(
                        operation.procedure!,
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right, size: 30.0),
                      onTap: () {
                        Get.to(() => EditSurgicalLog(operation: operation));
                      },
                    );
                  },
                ),
              );
            }
        }
      },
    );
  }

  Future<void> _initAllOperationsData() async {
    final getAllOperations =
        await _dataServices.getOperationsLogsByEmail(widget.userEmail);
    allOperation = getAllOperations;
  }

  Future<void> _refresh() async {
    final getAllOperations =
        await _dataServices.getOperationsLogsByEmail(widget.userEmail);
    setState(() {
      allOperation = getAllOperations;
    });
  }
}
