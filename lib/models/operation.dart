import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/doctor_user.dart';

class Operation {
  String? uid,
      patientName,
      patientFileNumber,
      procedure,
      leftEye,
      rightEye,
      postOpLeftEye,
      postOpRightEye,
      complications;
  DateTime? operationDate;
  DoctorUser? doctorUser;

  Operation({
    this.uid,
    this.patientName,
    this.patientFileNumber,
    this.procedure,
    this.leftEye,
    this.rightEye,
    this.postOpLeftEye,
    this.postOpRightEye,
    this.complications,
    this.operationDate,
    this.doctorUser,
  });

  Map<String, dynamic> toFirebaseMap() {
    return {
      'patientName': patientName,
      'patientFileNumber': patientFileNumber,
      'procedure': procedure,
      'leftEye': leftEye,
      'rightEye': rightEye,
      'postOpLeftEye': postOpLeftEye,
      'postOpRightEye': postOpRightEye,
      'complications': complications,
      'operationDate': operationDate,
      'doctorUser': doctorUser!.toMap(),
    };
  }

  factory Operation.fromFirebaseMap(Map<String, dynamic> map, String uid) {
    return Operation(
      uid: uid,
      patientName: map['patientName'] as String,
      patientFileNumber: map['patientFileNumber'] as String,
      procedure: map['procedure'] as String,
      leftEye: map['leftEye'] as String,
      rightEye: map['rightEye'] as String,
      postOpLeftEye: map['postOpLeftEye'] as String,
      postOpRightEye: map['postOpRightEye'] as String,
      complications: map['complications'] as String,
      operationDate: (map['operationDate'] as Timestamp).toDate(),
      doctorUser: DoctorUser.fromMap(map['doctorUser']),
    );
  }
}
