import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import '/models/quiz.dart';
import '/services/data_services.dart';
import '/views/quizzes_questions/quiz_details_view.dart';
import '/views/quizzes_questions/quiz_view.dart';

class QuizzesListViewController extends StatelessWidget {
  QuizzesListViewController({Key? key}) : super(key: key);
  final DataServices _dataServices = Get.find();

  @override
  Widget build(BuildContext context) {
    return _dataServices.doctorUser.value.containsRole('admin')
        ? AdminQuizzesListView()
        : const ResidentQuizzesListView();
  }
}

class AdminQuizzesListView extends StatelessWidget {
  AdminQuizzesListView({Key? key}) : super(key: key);
  final DataServices _dataServices = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: _dataServices.allQuizzes.length,
              itemBuilder: (BuildContext context, int index) {
                Quiz quiz = _dataServices.allQuizzes[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.only(right: 12.0),
                    decoration: const BoxDecoration(
                        border: Border(right: BorderSide(width: 0.7))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('MMM')
                            .format(DateTime(0, quiz.creationDate!.month))),
                        Text(quiz.creationDate!.day.toString()),
                      ],
                    ),
                  ),
                  title: Text(
                    quiz.title!,
                  ),
                  subtitle: Text(
                    quiz.creator!,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 30.0),
                  onTap: () {
                    Get.to(() => QuizDetailsView(
                          quiz: quiz,
                        ));
                  },
                );
              },
            )));
  }
}

class ResidentQuizzesListView extends StatelessWidget {
  const ResidentQuizzesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataServices _dataServices = Get.find();
    return Scaffold(
        body: Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: _dataServices.allQuizzes.length,
              itemBuilder: (BuildContext context, int index) {
                Quiz quiz = _dataServices.allQuizzes[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.only(right: 12.0),
                    decoration: const BoxDecoration(
                        border: Border(right: BorderSide(width: 0.7))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('MMM')
                            .format(DateTime(0, quiz.creationDate!.month))),
                        Text(quiz.creationDate!.day.toString()),
                      ],
                    ),
                  ),
                  title: Text(
                    quiz.title!,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 30.0),
                  onTap: () {
                    Get.to(() => QuizView(
                          quiz: quiz,
                        ));
                  },
                );
              },
            )));
  }
}
