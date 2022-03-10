class Resident {
  String? id, name, phone, fileNumber;

  Resident({this.id, this.name, this.phone, this.fileNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'fileNumber': fileNumber,
    };
  }

  factory Resident.fromMap(Map<String, dynamic> map) {
    return Resident(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      fileNumber: map['fileNumber'] as String,
    );
  }

  factory Resident.fromFirebase(Map<String, dynamic> map, String uid) {
    return Resident(
      id: uid,
      name: map['name'] as String,
      phone: map['phone'] as String,
      fileNumber: map['fileNumber'] as String,
    );
  }

  Map<String, dynamic> toFirebaseMap() {
    return {
      'name': name,
      'phone': phone,
      'fileNumber': fileNumber,
    };
  }
}
