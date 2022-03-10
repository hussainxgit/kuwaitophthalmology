import 'package:flutter/material.dart';
import '/models/quiz.dart';

class QuizQuestion extends StatefulWidget {

  final Question question;

  const QuizQuestion(
      {Key? key,
      required this.question,})
      : super(key: key);

  @override
  _QuizQuestionState createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  int? selectedAnswer;

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
              title: Text(widget.question.question!,
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
                itemCount: widget.question.choices!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: widget.question.choices![index].isChosen ? Colors.blue : Colors.black45),
                    ),
                    onTap: () {
                      if (widget.question.choices![index].isChosen) {
                        setState(() {
                          for (var element in widget.question.choices!) {
                            element.isChosen = false;
                          }
                          widget.question.choices![index].isChosen = false;
                        });
                      } else {
                        setState(() {
                          for (var element in widget.question.choices!) {
                            element.isChosen = false;
                          }
                          widget.question.choices![index].isChosen = true;
                        });
                      }
                    },
                    title: Text(widget.question.choices![index].choice),
                    trailing: widget.question.choices![index].isChosen ? const Icon(Icons.done, color: Colors.blue,) : const Icon(Icons.circle_outlined),

                  );
                }),
            const Divider(),
          ],
        )
      ],
    );
  }
}
