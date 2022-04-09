import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:kuwaitophthalmology/services/api_services.dart';

import '/services/data_services.dart';

class AllLeavesView extends StatefulWidget {
  const AllLeavesView({Key? key}) : super(key: key);

  @override
  _AllLeavesViewState createState() => _AllLeavesViewState();
}

class _AllLeavesViewState extends State<AllLeavesView> {
  final DataServices _dataServices = Get.find();
  final ApiServices _apiServices = ApiServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Center(child: Text('All Leaves')),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _dataServices.allLeaves.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor:
                      _dataServices.allLeaves[index].isLeaveDenied() != null
                          ? Colors.redAccent
                          : Colors.white,
                  title: Text(
                      _dataServices.allLeaves[index].user.name!.toUpperCase()),
                  subtitle: Text(_dataServices.allLeaves[index].startDate
                      .toIso8601String()),
                );
              }),
          const Center(child: Text('Program director')),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _dataServices.allLeaves.length,
              itemBuilder: (context, index) {
                if (_dataServices.allLeaves[index].isLeaveDenied() == null &&
                    _dataServices.allLeaves[index].isResident() == true &&
                    _dataServices.allLeaves[index]
                            .approvedByProgramDirector() ==
                        false) {
                  return ListTile(
                    tileColor:
                        _dataServices.allLeaves[index].isLeaveDenied() != null
                            ? Colors.redAccent
                            : Colors.white,
                    title: Text(_dataServices.allLeaves[index].user.name!
                        .toUpperCase()),
                    subtitle: Text(_dataServices.allLeaves[index].startDate
                        .toIso8601String()),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () {
                            _apiServices.approveLeave(
                                _dataServices.allLeaves[index],
                                _dataServices.currentUser.value,
                                'Have a great leave');
                          },
                          icon: const Icon(Icons.done),
                          splashRadius: 24.0,
                        ),
                        IconButton(
                          onPressed: () {
                            _apiServices.denyLeave(
                                _dataServices.allLeaves[index],
                                _dataServices.currentUser.value,
                                'Insufficient leave credit');
                          },
                          icon: const Icon(Icons.close),
                          splashRadius: 24.0,
                        )
                      ],
                    ),
                  );
                }
                return const Center(child: Text('empty'));
              }),
          const Center(child: Text('Head of unit')),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _dataServices.allLeaves.length,
              itemBuilder: (context, index) {
                if (_dataServices.allLeaves[index].isLeaveDenied() == null &&
                    _dataServices.allLeaves[index].approvedByHeadOfUnit() ==
                        false &&
                    (_dataServices.allLeaves[index].isResident() == true &&
                            _dataServices.allLeaves[index]
                                    .approvedByProgramDirector() ==
                                true ||
                        _dataServices.allLeaves[index].isResident() == false)) {
                  return ListTile(
                    tileColor:
                        _dataServices.allLeaves[index].isLeaveDenied() != null
                            ? Colors.redAccent
                            : Colors.white,
                    title: Text(_dataServices.allLeaves[index].user.name!
                        .toUpperCase()),
                    subtitle: Text(_dataServices.allLeaves[index].startDate
                        .toIso8601String()),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () {
                            _apiServices.approveLeave(
                                _dataServices.allLeaves[index],
                                _dataServices.currentUser.value,
                                'Have a great leave');
                          },
                          icon: const Icon(Icons.done),
                          splashRadius: 24.0,
                        ),
                        IconButton(
                          onPressed: () {
                            _apiServices.denyLeave(
                                _dataServices.allLeaves[index],
                                _dataServices.currentUser.value,
                                'Insufficient leave credit');
                          },
                          icon: const Icon(Icons.close),
                          splashRadius: 24.0,
                        )
                      ],
                    ),
                  );
                }
                return const Center(child: Text('empty'));
              }),
          const Center(child: Text('Head of department')),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _dataServices.allLeaves.length,
              itemBuilder: (context, index) {
                if (_dataServices.allLeaves[index].isLeaveDenied() == null &&
                    _dataServices.allLeaves[index].approvedByHeadOfUnit() ==
                        true &&
                    _dataServices.allLeaves[index]
                            .approvedByHeadOfDepartment() ==
                        false) {
                  return ListTile(
                    tileColor:
                        _dataServices.allLeaves[index].isLeaveDenied() != null
                            ? Colors.redAccent
                            : Colors.white,
                    title: Text(_dataServices.allLeaves[index].user.name!
                        .toUpperCase()),
                    subtitle: Text(_dataServices.allLeaves[index].startDate
                        .toIso8601String()),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () {
                            _apiServices.approveLeave(
                                _dataServices.allLeaves[index],
                                _dataServices.currentUser.value,
                                'Have a great leave');
                          },
                          icon: const Icon(Icons.done),
                          splashRadius: 24.0,
                        ),
                        IconButton(
                          onPressed: () {
                            _apiServices.denyLeave(
                                _dataServices.allLeaves[index],
                                _dataServices.currentUser.value,
                                'Insufficient leave credit');
                          },
                          icon: const Icon(Icons.close),
                          splashRadius: 24.0,
                        )
                      ],
                    ),
                  );
                }
                return const Center(child: Text('empty'));
              }),
        ],
      ),
    );
  }
}
