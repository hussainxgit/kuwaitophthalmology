import 'package:cloud_firestore/cloud_firestore.dart';

import 'resident.dart';

class Lecture {
  String? id, location, lecturer, subject;
  DateTime? date;
  List<Map<String, dynamic>>? residents = [];
  List<Resident> getAttendedR = [];
  List<Map<String, dynamic>>? excusedAbsence = [];

  Lecture({
    this.id,
    this.date,
    this.location,
    this.lecturer,
    this.subject,
    this.residents,
    this.excusedAbsence,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'id': id,
      'date': date,
      'location': location,
      'lecturer': lecturer,
      'subject': subject,
      'excusedAbsence': excusedAbsence,
    };
    if (residents != null || residents!.isNotEmpty) {
      data.addAll({
        'residents': residents!.map<Map<String, dynamic>>((e) => e).toList(),
      });
    } else {
      data.addAll({'residents': []});
    }
    return data;
  }

  factory Lecture.fromMap(Map<String, dynamic> map) {
    Timestamp timestampDate = map['date'] as Timestamp;
    return Lecture(
      id: map['id'] as String,
      location: map['location'] as String,
      lecturer: map['lecturer'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(timestampDate.seconds * 1000),
      subject: map['subject'] as String,
      residents: map['residents'].cast<String>(),
    );
  }

  factory Lecture.fromFirebase(Map<String, dynamic> map, String uid) {
    Timestamp timestampDate = map['date'] as Timestamp;
    return Lecture(
      id: uid,
      location: map['location'] as String,
      lecturer: map['lecturer'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(timestampDate.seconds * 1000),
      subject: map['subject'] as String,
      residents: map['residents'] != null
          ? (map['residents'] as List<dynamic>)
              .map<Map<String, dynamic>>((item) => item)
              .toList()
          : [],
      excusedAbsence: map['excusedAbsence'] != null
          ? (map['excusedAbsence'] as List<dynamic>)
              .map<Map<String, dynamic>>((item) => item)
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toFirebaseMap() {
    Map<String, dynamic> data = {
      'date': date,
      'location': location,
      'lecturer': lecturer,
      'subject': subject,
    };
    if (residents != null) {
      data.addAll({
        'residents': residents!.map<Map<String, dynamic>>((e) => e).toList(),
      });
    } else {
      data.addAll({'residents': []});
    }

    if (excusedAbsence != null) {
      data.addAll({
        'excusedAbsence': excusedAbsence,
      });
    } else {
      data.addAll({'excusedAbsence': []});
    }
    return data;
  }

  List<Resident>? getAttendedResidents(List<Resident> givenResident) {
    getAttendedR.clear();
    for (var resident in givenResident) {
      if (residents!.contains(resident.name)) {
        getAttendedR.add(resident);
      } else {
        return null;
      }
    }
    return getAttendedR;
  }

  Map<String, dynamic> getExcusedAbsenceByName(String name) {
    return excusedAbsence!.firstWhere((o) => o['name'] == name);
  }

  Map<String, dynamic> getAttendedByName(String name) {
    return residents!.firstWhere((o) => o['name'] == name);
  }
}
