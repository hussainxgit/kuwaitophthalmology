import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import '/services/data_services.dart';
import '/views/home_view.dart';
import '/views/splash_screen_view.dart';

class MainViewController extends StatelessWidget {
  MainViewController({Key? key}) : super(key: key);
  final DataServices _dataServices = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        _dataServices.isLogged.value ? const HomeView() : const SplashScreen());
  }
}
