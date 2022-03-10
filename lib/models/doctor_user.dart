import '/models/quiz.dart';

class DoctorUser {
  String? uid, name, email, phone, rotationYear;
  QuizResult? quizResult;
  List<String>? roles = [];

  DoctorUser({
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.rotationYear,
    this.quizResult,
    this.roles,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'rotation_year': rotationYear,
      'roles': roles,
    };
  }

  factory DoctorUser.fromMap(Map<String, dynamic> map, [String? uid]) {
    return DoctorUser(
      uid: uid,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      rotationYear: map['rotation_year'] ?? '',
      roles: map['roles'] != null
          ? (map['roles'] as List<dynamic>).map<String>((e) => e).toList()
          : [],
    );
  }

  bool isEmpty() {
    if (uid == '' &&
        name == '' &&
        email == '' &&
        phone == '' &&
        rotationYear == '') {
      return true;
    } else {
      return false;
    }
  }

  void clear() {
    uid = '';
    name = '';
    email = '';
    phone = '';
    rotationYear = '';
    roles?.clear();
  }

  bool containsRole(String role) {
    if (roles != null && roles!.contains(role)) {
      return true;
    } else {
      return false;
    }
  }
}
