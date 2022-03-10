import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import '/models/quiz.dart';
import '/services/data_services.dart';
import '/views/quizzes_questions/question_view.dart';

class AllQuestionsView extends StatelessWidget {
  AllQuestionsView({Key? key}) : super(key: key);
  final DataServices _dataServices = Get.find();

  @override
  Widget build(BuildContext context) {
    _dataServices.getAllQuestions();
    return Scaffold(
        body: Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: _dataServices.allQuestion.length,
              itemBuilder: (BuildContext context, int index) {
                Question question = _dataServices.allQuestion[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.only(right: 12.0),
                    decoration: const BoxDecoration(
                        border: Border(right: BorderSide(width: 0.7))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('MMM')
                            .format(DateTime(0, question.creationDate!.month))),
                        Text(question.creationDate!.day.toString()),
                      ],
                    ),
                  ),
                  title: Text(
                    question.question!,
                  ),
                  subtitle: Text(
                    question.creator!,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 30.0),
                  onTap: () {
                    Get.to(() => QuestionView(
                          question: question,
                        ));
                  },
                );
              },
            )));
  }
}
