class Assigned {
  final String? uid;
  final String elderUid;
  final String careTakerUid;
  final int assignedOn;

  const Assigned({
    required this.uid,
    required this.elderUid,
    required this.careTakerUid,
    required this.assignedOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'elderUid': elderUid,
      'careTakerUid': careTakerUid,
      'assignedOn': assignedOn,
    };
  }

  factory Assigned.fromMap(Map<String, dynamic> map) {
    return Assigned(
      uid: map['uid'],
      elderUid: map['elderUid'],
      careTakerUid: map['careTakerUid'],
      assignedOn: map['assignedOn'],
    );
  }
}
