import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kuwaitophthalmology/models/leave.dart';

import '/models/data_response.dart';
import '/models/doctor_user.dart';
import '/models/operation.dart';
import '/models/quiz.dart';
import '/services/api_services.dart';

class DataServices extends GetxController {
  final ApiServices _apiServices = ApiServices();
  Rx<DoctorUser> currentUser = DoctorUser().obs;
  Rx<bool> isLogged = false.obs;
  RxList<Quiz> allQuizzes = <Quiz>[].obs;
  RxList<Operation> currentUserAllOperations = <Operation>[].obs;
  RxList<Question> allQuestion = <Question>[].obs;
  RxList<Question> quizQuestions = <Question>[].obs;
  RxList<DoctorUser> quizParticipants = <DoctorUser>[].obs;
  RxList<QuizResult> quizResults = <QuizResult>[].obs;
  RxList<DoctorUser> allUsers = <DoctorUser>[].obs;
  RxList<Leave> allLeaves = <Leave>[].obs;

  DataServices();

  Future<RxList<Operation>> getOperationsLogsByEmail(String userEmail) async {
    currentUserAllOperations
        .assignAll(await _apiServices.getOperationsLogsByEmail(userEmail));
    currentUserAllOperations.sort((a, b) {
      return b.operationDate!.compareTo(a.operationDate!);
    });
    currentUserAllOperations.refresh();
    return currentUserAllOperations;
  }

  Future<List<Question>> getQuizQuestions(Quiz quiz) async {
    quizQuestions.assignAll(await _apiServices.getQuizQuestions(quiz));
    quizQuestions.refresh();
    return quizQuestions;
  }

  Future<RxList<Question>> getAllQuestions() async {
    allQuestion.assignAll(await _apiServices.getAllQuestions());
    allQuestion.refresh();
    return allQuestion;
  }

  Future<RxList<Quiz>> getAllQuizzes() async {
    allQuizzes.assignAll(await _apiServices.getAllQuizzes());
    allQuizzes.refresh();
    return allQuizzes;
  }

  Future<RxList<Quiz>> getResidentsUncompletedQuizzes(
      DoctorUser doctorUser) async {
    allQuizzes.assignAll(
        await _apiServices.getResidentUncompletedQuizzes(doctorUser));
    allQuizzes.refresh();
    return allQuizzes;
  }

  Future<RxList<Quiz>> getResidentsCompletedQuizzes(
      DoctorUser doctorUser) async {
    allQuizzes.assignAll(
        await _apiServices.getResidentUncompletedQuizzes(doctorUser));
    allQuizzes.refresh();
    return allQuizzes;
  }

  initAppMainData() async {
    await isUserSignedIn().then((value) {
      if (value == true) {
        if (currentUser.value.containsRole('admin')) {
          getAllQuestions();
          getAllQuizzes();
          getAllUsers();
        } else if (currentUser.value.containsRole('resident') &&
            currentUser.value.containsRole('admin') != true) {
          getResidentsUncompletedQuizzes(currentUser.value);
        }
        getOperationsLogsByEmail(currentUser.value.email!);
        getAllLeaves();
      }
    });
  }

  int getCurrentMonthLogs({required int monthInt}) {
    return currentUserAllOperations
        .where((o) => o.operationDate!.month == monthInt)
        .toList()
        .length;
  }

  Future<DataResponse> signInUser(String email, password) async {
    DataResponse response = await _apiServices.signInUser(email, password);
    if (response.onSuccess) {
      currentUser.value = response.object as DoctorUser;
      isLogged.value = true;
      isLogged.refresh();
      currentUser.refresh();
      initAppMainData();
    }
    return response;
  }

  Future signUpUser(DoctorUser user, String password) async {
    await _apiServices.signUpUser(user, password);
  }

  Future logoutUser() async {
    _apiServices.logout();
    currentUser.value.clear();
    isLogged.value = false;
  }

  Future<void> addQuestion(Question question) async {
    allQuestion.add(question);
    allQuestion.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    allQuestion.refresh();
    await _apiServices.addQuestion(question);
  }

  Future<void> removeQuestion(Question question) async {
    allQuestion.remove(question);
    allQuestion.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    allQuestion.refresh();
    await _apiServices.deleteQuestion(question);
  }

  Future<void> createQuiz(Quiz quiz) async {
    allQuizzes.add(quiz);
    allQuizzes.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    allQuizzes.refresh();
    await _apiServices.createQuiz(quiz);
  }

  Future<void> removeQuiz(Quiz quiz) async {
    allQuizzes.remove(quiz);
    allQuizzes.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    allQuizzes.refresh();
    await _apiServices.deleteQuiz(quiz);
  }

  removeFromLocalQuiz(Quiz quiz) async {
    allQuizzes.remove(quiz);
    allQuizzes.refresh();
  }

  getQuizResults(Quiz quiz) async {
    quizResults.value = await _apiServices.getQuizResults(quiz);
    quizParticipants.value = await _apiServices.getQuizParticipants(quiz);
    for (int i = 0; i < quizParticipants.length; i++) {
      for (var e in quizResults) {
        if (e.doctorUid == quizParticipants[i].uid) {
          quizParticipants[i].quizResult = e;
        } else {}
      }
    }
    quizResults.refresh();
    quizParticipants.refresh();
  }

  Future<void> getAllUsers() async {
    allUsers.value = await _apiServices.getAllUsers();
  }

  Future<void> getAllLeaves() async {
    allLeaves.value = await _apiServices.getAllLeaves();
  }

  Future<bool> isUserSignedIn() async {
    return await _apiServices.isUserLoggedIn().then((value) async {
      if (value != null) {
        currentUser.value = (await _apiServices.isUserLoggedIn())!;
        isLogged.value = true;
        isLogged.refresh();
        currentUser.refresh();
        return true;
      }
      return false;
    });
  }

  Future<void> addOperation(Operation operation) async {
    await _apiServices
        .addOperationLog(operation)
        .whenComplete(() => currentUserAllOperations.add(operation));
    currentUserAllOperations.refresh();
  }

  Future<void> editOperation(Operation operation) async {
    await _apiServices
        .editOperationLog(operation)
        .whenComplete(() => getOperationsLogsByEmail(currentUser.value.email!));
    currentUserAllOperations.refresh();
  }

  Future<void> createLeave(Leave leave) async {
    await _apiServices.createLeave(leave);
    allLeaves.refresh();
  }
}
