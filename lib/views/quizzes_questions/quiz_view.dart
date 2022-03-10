import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import '/models/quiz.dart';
import '/services/api_services.dart';
import '/services/data_services.dart';
import '/views/quizzes_questions/quiz_question.dart';
import '/widgets/custom_dialogs.dart';
import 'package:timer_count_down/timer_count_down.dart';

class QuizView extends StatefulWidget {
  final Quiz quiz;

  const QuizView({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  final DataServices _dataServices = Get.find();
  final ApiServices _apiServices = ApiServices();
  List<Map<String, dynamic>> chosenAnswers = [];
  List<Question> quizQuestions = [];
  int durationInSeconds = 0;
  int durationInMinutes = 0;
  int quizDurationResult = 0;
  int score = 0;

  @override
  void initState() {
    durationInSeconds = widget.quiz.duration!.round();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    durationInMinutes = (durationInSeconds / 60).round();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
            '${widget.quiz.questions!.length}/${chosenAnswers.length} answered'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Countdown(
                seconds: durationInSeconds,
                build: (BuildContext ctx, double time) {
                  quizDurationResult = durationInSeconds - time.round();
                  return Text(
                    time < 60
                        ? time.toString() + 's'
                        : (time / 60).round().toString() + ' m',
                    style: TextStyle(
                        color: time < 60 ? Colors.redAccent : Colors.white),
                  );
                },
                interval: const Duration(milliseconds: 100),
                onFinished: () {
                  quizFinish(context);
                },
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: widget.quiz.questions!.length,
                itemBuilder: (BuildContext context, index) {
                  return QuizQuestion(question: widget.quiz.questions![index]);
                }),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  makeSureDialog(context).then(
                      (value) => value == true ? quizFinish(context) : null);
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.lightBlue, Colors.blueAccent],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(
                        minHeight: 50, maxWidth: double.infinity),
                    child: const Text(
                      "Finish",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> quizFinish(BuildContext context) async {
    for (var element in widget.quiz.questions!) {
      for (var element in element.choices!) {
        if (element.isChosen && element.isAnswer) {
          score++;
        }
      }
    }
    _apiServices
        .addQuizResult(QuizResult(
            doctorUid: _dataServices.doctorUser.value.uid,
            quizUid: widget.quiz.uid,
            duration: quizDurationResult,
            score: score,
            chosenAnswers: widget.quiz.questions))
        .whenComplete(() => _dataServices
            .removeFromLocalQuiz(widget.quiz)
            .whenComplete(() => showQuizScore(context, score)));
  }
}
