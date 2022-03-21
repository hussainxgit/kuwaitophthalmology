import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import '/models/quiz.dart';
import '/services/data_services.dart';
import '/widgets/custom_app_bar.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DataServices _dataServices = Get.find();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController choicesController = TextEditingController();
  Map<String, dynamic> questionChoices = {};
  DateTime selectedDate = DateTime.now();
  List<int> answers = [];

  Future<DateTime?> showDate(BuildContext context) async {
    return await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(1998),
            lastDate: DateTime(2100)) ??
        selectedDate;
  }

  Question question = Question(choices: []);
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actionList: [
          (isLoading)
              ? Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1.5,
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.save),
                  tooltip: 'Send',
                  onPressed: () => submit(),
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
                      'Add Question',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: questionController,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Write your question';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Write Question",
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
                      height: 20.0,
                    ),
                    TextFormField(
                      onEditingComplete: () {
                        setState(() {
                          if (choicesController.text.isNotEmpty) {
                            question.choices!.add(Choice(
                                choice: choicesController.text,
                                isAnswer: false,
                                isChosen: false
                            ));
                          }
                        });
                      },
                      controller: choicesController,
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Create choices",
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
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: question.choices!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: SizedBox(
                                child: Text((index + 1).toString() + ' -')),
                            title: Text(question.choices![index].choice),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                (question.choices![index].isAnswer == false)
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            question.choices![index].isAnswer =
                                                true;
                                          });
                                        },
                                        icon: const Icon(Icons.done))
                                    : IconButton(
                                        onPressed: () {
                                          setState(() {
                                            question.choices![index].isAnswer =
                                                false;
                                          });
                                        },
                                        icon: const Icon(Icons.close)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        question.choices!
                                            .remove(question.choices![index]);
                                      });
                                    },
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                          );
                        }),
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      if (question.choices!.isEmpty) {
        return;
      }
      question.creator = _dataServices.currentUser.value.name;
      question.question = questionController.text;
      question.creationDate = selectedDate;
      _dataServices.addQuestion(question).whenComplete(() => Get.back());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dateCtl.dispose();
    choicesController.dispose();
    questionController.dispose();
  }
}
