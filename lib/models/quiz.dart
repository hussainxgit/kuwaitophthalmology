import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  String? uid, title, creator;
  DateTime? creationDate, startDate, deadlineDate;
  List<String>? participants = [], completedParticipants = [];
  int? duration;
  List<Question>? questions = [];

  Quiz({
    this.uid,
    this.title,
    this.creator,
    this.creationDate,
    this.startDate,
    this.deadlineDate,
    this.participants,
    this.questions,
    this.duration,
    this.completedParticipants,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'creator': creator,
      'creationDate': creationDate,
      'startDate': startDate,
      'deadlineDate': deadlineDate,
      'participants': participants,
      'questions1': questions!.map((e) => e.toMap2()).toList(),
      'duration': duration,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map, String uid) {
    return Quiz(
      uid: uid,
      title: map['title'] as String,
      creator: map['creator'] as String,
      duration: map['duration'] as int,
      creationDate: (map['creationDate'] as Timestamp).toDate(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      deadlineDate: (map['deadlineDate'] as Timestamp).toDate(),
      participants:
          (map['participants'] as List<dynamic>).map<String>((e) => e).toList(),
      questions: (map['questions1'] as List<dynamic>)
          .map<Question>((e) => Question.fromMap2(e))
          .toList(),
      completedParticipants: map['completed_participants'] != null
          ? (map['completed_participants'] as List<dynamic>)
              .map<String>((e) => e)
              .toList()
          : [],
    );
  }
}

class QuizResult {
  String? uid, doctorUid, quizUid;
  int? duration, score;
  List<Question>? chosenAnswers = [];
  Timestamp? documentDate;

  QuizResult({
    this.uid,
    this.doctorUid,
    this.quizUid,
    this.duration,
    this.score,
    this.chosenAnswers,
    this.documentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctorUid': doctorUid,
      'quizUid': quizUid,
      'duration': duration,
      'score': score,
      'chosenAnswers': chosenAnswers!.map((e) => e.toMap2()).toList(),
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map, String uid) {
    return QuizResult(
      uid: uid,
      doctorUid: map['doctorUid'] as String,
      quizUid: map['quizUid'] as String,
      duration: map['duration'] as int,
      score: map['score'] as int,
      chosenAnswers: (map['chosenAnswers'] as List<dynamic>)
          .map((e) => Question.fromMap2(e))
          .toList(),
      // documentDate: map['documentDate'] as Timestamp,
    );
  }
}

class Question {
  String? uid, question, creator;
  DateTime? creationDate;
  List<Choice>? choices = [];

  Question({
    this.uid,
    this.question,
    this.choices,
    this.creator,
    this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'choices1': choices!.map((e) => e.toMap()).toList(),
      'creator': creator,
      'creationDate': creationDate,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map, String uid) {
    return Question(
        uid: uid,
        question: map['question'] as String,
        creator: map['creator'] as String,
        creationDate: (map['creationDate'] as Timestamp).toDate(),
        choices: (map['choices1'] as List<dynamic>)
            .map((e) => Choice.fromMap(e))
            .toList());
  }

  factory Question.fromMap2(Map<String, dynamic> map) {
    return Question(
        uid: map['uid'] as String,
        question: map['question'] as String,
        creator: map['creator'] as String,
        creationDate: (map['creationDate'] as Timestamp).toDate(),
        choices: (map['choices1'] as List<dynamic>)
            .map((e) => Choice.fromMap(e))
            .toList());
  }

  Map<String, dynamic> toMap2() {
    return {
      'uid': uid,
      'question': question,
      'choices1': choices!.map((e) => e.toMap()).toList(),
      'creator': creator,
      'creationDate': creationDate,
    };
  }
}

class Choice {
  String choice;
  bool isAnswer;
  bool isChosen;

  Choice({required this.choice, required this.isAnswer, required this.isChosen});

  Map<String, dynamic> toMap() {
    return {
      'choice': choice,
      'isAnswer': isAnswer,
      'isChosen': isChosen,
    };
  }

  factory Choice.fromMap(Map<String, dynamic> map) {
    return Choice(
      choice: map['choice'] as String,
      isAnswer: map['isAnswer'] as bool,
      isChosen: map['isChosen'] as bool,
    );
  }
}
