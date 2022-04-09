import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '/models/data_response.dart';
import '/models/doctor_user.dart';
import '/models/lecture.dart';
import '/models/operation.dart';
import '/models/quiz.dart';
import '/models/resident.dart';
import '../models/leave.dart';

class ApiServices {
  final CollectionReference _operationsLogCollection =
      FirebaseFirestore.instance.collection('operationsLog');

  final CollectionReference _questionsCollection =
      FirebaseFirestore.instance.collection('questions');

  final CollectionReference _quizzesCollection =
      FirebaseFirestore.instance.collection('quizes');

  final CollectionReference _quizzesResultCollection =
      FirebaseFirestore.instance.collection('quizzes_result');

  final CollectionReference _doctorUsersCollection =
      FirebaseFirestore.instance.collection('doctor_users');

  final CollectionReference _residentsCollection =
      FirebaseFirestore.instance.collection('residents');

  final CollectionReference _lecturesCollection =
      FirebaseFirestore.instance.collection('lectures');

  final CollectionReference _leavesCollection =
      FirebaseFirestore.instance.collection('leaves');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DataResponse _dataResponse = DataResponse();

  Future addOperationLog(Operation operation) async {
    return await _operationsLogCollection.doc().set(operation.toFirebaseMap());
  }

  Future editOperationLog(Operation operation) async {
    return await _operationsLogCollection
        .doc(operation.uid)
        .update(operation.toFirebaseMap());
  }

  Future<Operation> getOperation(String operationUid) async {
    return await _operationsLogCollection.doc(operationUid).get().then(
        (document) => Operation.fromFirebaseMap(
            document.data() as Map<String, dynamic>, document.id));
  }

  Future<List<Operation>> getOperationsLogsByEmail(String email) async {
    List<Operation> operations = await _operationsLogCollection.get().then(
        (collection) => collection.docs
            .map((document) => Operation.fromFirebaseMap(
                document.data() as Map<String, dynamic>, document.id))
            .toList()
            .where((e) => e.doctorUser?.email == email)
            .toList());
    return operations;
  }

  Future<List<Question>> getAllQuestions() async {
    List<Question> questions = await _questionsCollection.get().then(
        (collection) => collection.docs
            .map((document) => Question.fromMap(
                document.data() as Map<String, dynamic>, document.id))
            .toList());
    questions.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    return questions;
  }

  Future addQuestion(Question question) async {
    return await _questionsCollection.doc().set(question.toMap());
  }

  Future deleteQuestion(Question question) async {
    return await _questionsCollection.doc(question.uid).delete();
  }

  Future createQuiz(Quiz quiz) async {
    return await _quizzesCollection.doc().set(quiz.toMap());
  }

  Future deleteQuiz(Quiz quiz) async {
    return await _quizzesCollection.doc(quiz.uid).delete();
  }

  Future<List<Quiz>> getAllQuizzes() async {
    List<Quiz> quizzes = await _quizzesCollection.get().then((collection) =>
        collection.docs
            .map((document) => Quiz.fromMap(
                document.data() as Map<String, dynamic>, document.id))
            .toList());
    quizzes.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    return quizzes;
  }

  Future<List<Quiz>> getResidentUncompletedQuizzes(
      DoctorUser doctorUser) async {
    List<Quiz> quizzes = await _quizzesCollection
        .orderBy('creationDate', descending: true)
        .get()
        .then((collection) => collection.docs
            .map((document) => Quiz.fromMap(
                document.data() as Map<String, dynamic>, document.id))
            .toList()
            .where((element) =>
                element.completedParticipants!.contains(doctorUser.uid) != true)
            .toList());
    return quizzes;
  }

  Future<List<Quiz>> getResidentCompletedQuizzes(DoctorUser doctorUser) async {
    List<Quiz> quizzes = await _quizzesCollection
        .orderBy('creationDate', descending: true)
        .get()
        .then((collection) => collection.docs
            .map((document) => Quiz.fromMap(
                document.data() as Map<String, dynamic>, document.id))
            .toList()
            .where((element) =>
                element.completedParticipants!.contains(doctorUser.uid))
            .toList());
    return quizzes;
  }

  Future<List<Question>> getQuizQuestions(Quiz quiz) async {
    List<Question> questions = await _questionsCollection
        .where(FieldPath.documentId, whereIn: quiz.questions)
        .get()
        .then((value) => value.docs
            .map(
                (e) => Question.fromMap(e.data() as Map<String, dynamic>, e.id))
            .toList());
    questions.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    return questions;
  }

  Future addQuizResult(QuizResult quizResult) async {
    await _quizzesResultCollection.doc().set(quizResult.toMap());
    return await _quizzesCollection.doc(quizResult.quizUid).update({
      "completed_participants": FieldValue.arrayUnion([quizResult.doctorUid])
    });
  }

  Future<List<QuizResult>> getQuizResults(Quiz quiz) async {
    List<QuizResult> quizResults = await _quizzesResultCollection
        .where('quizUid', isEqualTo: quiz.uid)
        .get()
        .then((value) => value.docs
            .map((e) =>
                QuizResult.fromMap(e.data() as Map<String, dynamic>, e.id))
            .toList());
    return quizResults;
  }

  Future<List<DoctorUser>> getQuizParticipants(Quiz quiz) async {
    List<DoctorUser> quizParticipants = await _doctorUsersCollection
        .where('rotation_year', whereIn: quiz.participants)
        .get()
        .then((value) => value.docs
            .map((e) =>
                DoctorUser.fromMap(e.data() as Map<String, dynamic>, e.id))
            .toList());
    return quizParticipants;
  }

  Future<DoctorUser?> isUserLoggedIn() async {
    if (_auth.currentUser == null) {
      return null;
    } else {
      return getDoctorUserInfo(_auth.currentUser!.uid);
    }
  }

  Future<DataResponse> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _dataResponse.setSuccess(
          'Logged in', await getDoctorUserInfo(userCredential.user!.uid));
      return _dataResponse;
    } on FirebaseAuthException catch (e) {
      _dataResponse.setError(e.code);
      return _dataResponse;
    }
  }

  Future<void> signUpUser(DoctorUser user, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email!,
            password: password,
          )
          .then((value) async => await _doctorUsersCollection
              .doc(value.user!.uid)
              .set(user.toMap()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    if (await _auth.authStateChanges().isEmpty) {
      return;
    } else {
      _auth.signOut();
    }
  }

  Future<DataResponse> userForgotPassword(String email) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: email)
          .whenComplete(() => _dataResponse.setSuccess('Email sent.'));
    } on FirebaseAuthException catch (e) {
      _dataResponse.setError(e.code);
    }
    return _dataResponse;
  }

  Future<DoctorUser> getDoctorUserInfo(String uid) async {
    return await _doctorUsersCollection.doc(uid).get().then((value) =>
        DoctorUser.fromMap(value.data() as Map<String, dynamic>, value.id));
  }

  Future addLecture(Lecture lecture) async {
    return await _lecturesCollection.doc().set(lecture.toMap());
  }

  // get lecture by uid
  Future<Lecture> getLecture(String lectureUid) async {
    return await _lecturesCollection.doc(lectureUid).get().then((document) =>
        Lecture.fromFirebase(
            document.data() as Map<String, dynamic>, document.id));
  }

  // get all lectures
  Future<List<Lecture>> getAllLectures() async {
    List<Lecture> lectures = await _lecturesCollection.get().then(
        (collection) => collection.docs
            .map((document) => Lecture.fromFirebase(
                document.data() as Map<String, dynamic>, document.id))
            .toList());
    lectures.sort((a, b) {
      return b.date!.compareTo(a.date!);
    });
    return lectures;
  }

  // get today lecture
  Future<Lecture> getTodayLecture() async {
    DateTime dateToday =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    QuerySnapshot<Object?> query =
        await _lecturesCollection.where('date', isEqualTo: dateToday).get();
    return Lecture.fromFirebase(
        query.docs.first.data() as Map<String, dynamic>, query.docs.first.id);
  }

  Future<bool> attendResident(Lecture lecture, Resident resident) async {
    List<Map<String, dynamic>> lectureAttendees =
        await getLecture(lecture.id!).then((value) => value.residents!);
    if (lectureAttendees.contains(resident.id)) {
      return false;
    } else {
      String _now = DateFormat('hh:mm a').format(DateTime.now());
      lectureAttendees.add({'name': resident.name, 'time': _now});
      return await _lecturesCollection
          .doc(lecture.id)
          .update({'residents': lectureAttendees}).then((value) => true);
    }
  }

  Future<bool> absentResident(Lecture lecture, Resident resident) async {
    List<Map<String, dynamic>> lectureAttendees =
        await getLecture(lecture.id!).then((value) => value.residents!);

    lectureAttendees.removeWhere((item) => item['name'] == resident.name);

    return await _lecturesCollection
        .doc(lecture.id)
        .update({'residents': lectureAttendees}).then((value) => true);
  }

  Future<bool> excusedAbsenceResident(
      Lecture lecture, Resident resident, String reason) async {
    List<Map<String, dynamic>> excusedAbsence = lecture.excusedAbsence!;
    excusedAbsence.removeWhere((e) => e['name'] == resident.name);
    excusedAbsence.add({'name': resident.name, 'reason': reason});

    return await _lecturesCollection
        .doc(lecture.id)
        .update({'excusedAbsence': excusedAbsence}).then((value) => true);
  }

  Future<bool> removeExcusedAbsenceResident(
      Lecture lecture, Resident resident, String reason) async {
    List<Map<String, dynamic>> excusedAbsence = lecture.excusedAbsence!;
    excusedAbsence.removeWhere((e) => e['name'] == resident.name);
    return await _lecturesCollection
        .doc(lecture.id)
        .update({'excusedAbsence': excusedAbsence}).then((value) => true);
  }

  Future addResident(Resident resident) async {
    return await _residentsCollection.doc().set(resident.toFirebaseMap());
  }

  Future<List<DoctorUser>> getAllUsers() async {
    List<DoctorUser> residents = await _doctorUsersCollection.get().then(
        (collection) => collection.docs
            .map((document) => DoctorUser.fromMap(
                document.data() as Map<String, dynamic>, document.id))
            .toList());
    residents.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });

    return residents;
  }

  Future<bool> editResident(Resident resident) async {
    return await _residentsCollection
        .doc(resident.id)
        .update(resident.toFirebaseMap())
        .then((value) => true);
  }

  Future<bool> editLecture(Lecture lecture) async {
    return await _lecturesCollection
        .doc(lecture.id)
        .update(lecture.toFirebaseMap())
        .then((value) => true);
  }

  Future<bool> deleteLecture(Lecture lecture) async {
    return await _lecturesCollection
        .doc(lecture.id)
        .delete()
        .then((value) => true);
  }

  Future createLeave(Leave leave) async {
    return await _leavesCollection.doc().set(leave.toMap());
  }

  Future<List<Leave>> getAllLeaves() async {
    return await _leavesCollection.get().then((value) => value.docs
        .map((e) => Leave.fromMap(e.data() as Map<String, dynamic>, e.id))
        .toList());
  }

  Future approveLeave(Leave leave, DoctorUser approvalUser, msg) async {
    return await _leavesCollection.doc(leave.uid).update({
      'approvals': FieldValue.arrayUnion([
        {
          'uid': approvalUser.uid,
          'state': true,
          'msg': msg,
          'approvalLevel': approvalUser.roles!.first,
          'date': DateTime.now()
        }
      ])
    });
  }

  Future denyLeave(Leave leave, DoctorUser denierUser, msg) async {
    return await _leavesCollection.doc(leave.uid).update({
      'approvals': FieldValue.arrayUnion([
        {
          'uid': denierUser.uid,
          'state': false,
          'msg': msg,
          'approvalLevel': denierUser.roles!.first,
          'date': DateTime.now()
        }
      ])
    });
  }
}
