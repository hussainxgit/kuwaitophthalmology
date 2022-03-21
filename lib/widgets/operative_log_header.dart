import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import '/services/data_services.dart';

class OperativeLogHeader extends StatelessWidget {
  OperativeLogHeader({Key? key}) : super(key: key);
  final int currentMonth = DateTime.now().month;
  final DataServices _dataServices = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operative logs',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          "Feb, 2022",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(
          height: 23.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text(
                  _dataServices.currentUserAllOperations.length.toString(),
                  style: Theme.of(context).textTheme.headline1,
                )),
            Image.asset(
                'graphics/home_logo.png',
                width: 120)
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.done_all_outlined),
                const SizedBox(
                  width: 8.0,
                ),
                Obx(() => Text(
                      _dataServices.currentUserAllOperations.length.toString() +
                          ' successful',
                      style: Theme.of(context).textTheme.subtitle2,
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
