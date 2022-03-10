import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import '/services/data_services.dart';
import '/views/user_view.dart';

class AllUsersView extends StatefulWidget {
  const AllUsersView({Key? key}) : super(key: key);

  @override
  _AllUsersViewState createState() => _AllUsersViewState();
}

class _AllUsersViewState extends State<AllUsersView> {
  final DataServices _dataServices = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: _dataServices.allUsers.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Get.to(() => UserView(user: _dataServices.allUsers[index]));
              },
              title: Text(_dataServices.allUsers[index].name!.toUpperCase()),
              subtitle: Text(_dataServices.allUsers[index].roles!.first.toUpperCase()),
            );
          }),
    );
  }
}
