import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import '/models/quiz.dart';
import '/services/data_services.dart';
import '/widgets/custom_app_bar.dart';

class QuestionView extends StatefulWidget {
  final Question question;

  const QuestionView({Key? key, required this.question})
      : super(
          key: key,
        );

  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  int? selectedAnswer;
  final DataServices _dataServices = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actionList: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () {
              _dataServices
                  .removeQuestion(widget.question)
                  .whenComplete(() => Get.back());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Column(
              children: [
                Text(widget.question.question!,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20.0,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.question.choices!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: selectedAnswer == index
                            ? Colors.green
                            : Colors.white,
                        onTap: () {
                          if (selectedAnswer == index) {
                            setState(() {
                              selectedAnswer = null;
                            });
                          } else {
                            setState(() {
                              selectedAnswer = index;
                            });
                          }
                        },
                        leading: SizedBox(
                            child: Text((index + 1).toString() + ' -')),
                        title: Text(widget.question.choices![index].choice),
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
