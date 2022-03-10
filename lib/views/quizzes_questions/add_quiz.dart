import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import '/models/quiz.dart';
import '/services/data_services.dart';
import '/widgets/custom_app_bar.dart';

class AddQuiz extends StatefulWidget {
  const AddQuiz({Key? key}) : super(key: key);

  @override
  State<AddQuiz> createState() => _AddQuizState();
}

class _AddQuizState extends State<AddQuiz> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  List<String> participants = [];
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  final DataServices _dataServices = Get.find();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  double durationInSeconds = 0;

  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(1998),
            lastDate: DateTime(2100)) ??
        selectedDate;
  }

  Future<DateTime?> _selectDate2(BuildContext context) async {
    return await showDatePicker(
            context: context,
            initialDate: selectedDate2,
            firstDate: DateTime(1998),
            lastDate: DateTime(2100)) ??
        selectedDate2;
  }

  Question question = Question();
  Quiz quiz = Quiz(questions: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actionList: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Create',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (participants.isEmpty) {
                  return;
                } else if (quiz.questions!.isEmpty) {
                  return;
                }
                durationInSeconds = double.parse(durationController.text) * 60;
                quiz.title = titleController.text;
                quiz.participants = participants;
                quiz.startDate = selectedDate;
                quiz.deadlineDate = selectedDate2;
                quiz.questions = quiz.questions;
                quiz.duration = durationInSeconds.round();
                quiz.creationDate = DateTime.now();
                quiz.creator = _dataServices.doctorUser.value.name;
                _dataServices.createQuiz(quiz).whenComplete(() => Get.back());
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Create Quiz',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: titleController,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Write Quiz title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Quiz title",
                        labelStyle: TextStyle(
                            fontSize: 14, color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text(
                      'Choose dates',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            _selectDate(context).then((value) => setState(() {
                                  selectedDate = value!;
                                }));
                          },
                          leading: const Text('Start in :'),
                          title: Text(formatter.format(selectedDate),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF000000))),
                          trailing: const Icon(Icons.calendar_today),
                        )),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            _selectDate2(context).then((value) => setState(() {
                                  selectedDate2 = value!;
                                }));
                          },
                          leading: const Text('Deadline:'),
                          title: Text(formatter.format(selectedDate2),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFF000000))),
                          trailing: const Icon(Icons.calendar_today),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: durationController,
                        keyboardType: TextInputType.phone,
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please specify duration of quiz';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Quiz duration in minutes",
                          labelStyle: TextStyle(
                              fontSize: 14, color: Colors.grey.shade400),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.blueAccent,
                              )),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text(
                      'Choose participants',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: participants
                                    .where((element) =>
                                        element == ('R${index + 1}'))
                                    .isNotEmpty
                                ? Colors.blueAccent
                                : Colors.white,
                            onTap: () {
                              setState(() {
                                if (participants
                                    .where((element) =>
                                        element == ('R${index + 1}'))
                                    .isNotEmpty) {
                                  participants.remove('R${index + 1}');
                                } else {
                                  participants.add('R${index + 1}');
                                }
                              });
                            },
                            title: Text('R${index + 1}'),
                          );
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Choose questions',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      physics: const ScrollPhysics(),
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
                                Text(DateFormat('MMM').format(
                                    DateTime(0, question.creationDate!.month))),
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
                          trailing: const Icon(Icons.keyboard_arrow_right,
                              size: 30.0),
                          tileColor: quiz.questions!
                                  .where((element) => element == question)
                                  .isNotEmpty
                              ? Colors.blueAccent
                              : Colors.white,
                          onTap: () {
                            setState(() {
                              if (quiz.questions!
                                  .where((element) => element == question)
                                  .isNotEmpty) {
                                quiz.questions!.remove(question);
                              } else {
                                quiz.questions!.add(question);
                              }
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
