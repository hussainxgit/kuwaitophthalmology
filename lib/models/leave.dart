import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/doctor_user.dart';

class Leave {
  String uid;
  DoctorUser user;
  List<Map<String, dynamic>> approvals = [];
  DateTime startDate, endDate;

  Leave({
    required this.uid,
    required this.user,
    required this.approvals,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'approvals': approvals,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Leave.fromMap(Map<String, dynamic> map, String uid) {
    return Leave(
      uid: uid,
      user: DoctorUser.fromMap(map['user']),
      approvals: (map['approvals'] as List<dynamic>)
          .map((e) => {
                'uid': e['uid'].toString(),
                'state': e['state'],
                'msg': e['msg'].toString(),
                'approvalLevel': e['approvalLevel'],
                'date': (e['date'] as Timestamp).toDate()
              })
          .toList(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic>? isLeaveDenied() {
    for (var e in approvals) {
      if (e['state'] == false) {
        return e;
      }
    }
    return null;
  }

  bool isResident() {
    if (user.roles!.first == 'resident') {
      return true;
    }
    return false;
  }

  bool approvedByHeadOfUnit() {
    for (var e in approvals) {
      if (e['approvalLevel'] == 'HeadOfUnit') {
        return true;
      }
    }
    return false;
  }

  bool approvedByHeadOfDepartment() {
    for (var e in approvals) {
      if (e['approvalLevel'] == 'HeadOfDepartment') {
        return true;
      }
    }
    return false;
  }

  bool approvedByProgramDirector() {
    for (var e in approvals) {
      if (e['approvalLevel'] == 'ProgramDirector') {
        return true;
      }
    }
    return false;
  }
}
