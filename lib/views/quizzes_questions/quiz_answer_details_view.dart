import 'package:flutter/material.dart';
import '/models/doctor_user.dart';
import '/models/quiz.dart';

class QuizAnswerDetailsView extends StatelessWidget {
  const QuizAnswerDetailsView({Key? key, required this.quizResult, required this.user})
      : super(key: key);
  final QuizResult quizResult;
  final DoctorUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(user.name!),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.score_outlined),
                      const SizedBox(width: 8,),
                      Text((quizResult.score!).toString())
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined),
                      const SizedBox(width: 8,),
                      Text((quizResult.duration! / 60).round().toString() + ' m')
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: quizResult.chosenAnswers!.length,
                  itemBuilder: (BuildContext context, index) {
                    return QuestionsWithAnswers(question: quizResult.chosenAnswers![index]);
                  }),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ));
  }
}

class QuestionsWithAnswers extends StatelessWidget {
  const QuestionsWithAnswers({Key? key, required this.question}) : super(key: key);
  final Question question;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(question.question!,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 16);
                },
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: question.choices!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: question.choices![index].isChosen ? Colors.blue : Colors.black45),
                    ),
                    title: Text(question.choices![index].choice),
                    trailing: question.choices![index].isChosen ? const Icon(Icons.done, color: Colors.blue,) : const Icon(Icons.circle_outlined),

                  );
                }),
            const Divider(),
          ],
        )
      ],
    );
  }
}

