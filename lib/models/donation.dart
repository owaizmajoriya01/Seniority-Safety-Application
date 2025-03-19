class Donation {
  final String? uid;
  final String? from;
  final String? oldAgeUid;
  final double? amount;
  final String? note;
  final int? timeStamp;
  final String? senderName;
  final String? receiverName;

  const Donation({
    this.uid,
    this.from,
    this.oldAgeUid,
    this.amount,
    this.note,
    this.timeStamp,
    this.senderName,
    this.receiverName,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'from': from,
      'oldAgeUid': oldAgeUid,
      'amount': amount,
      'note': note,
      'timeStamp': timeStamp,
      'senderName': senderName,
      'receiverName': receiverName,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      uid: map['uid'],
      from: map['from'],
      oldAgeUid: map['oldAgeUid'],
      amount: map['amount'],
      note: map['note'],
      timeStamp: map['timeStamp'],
      senderName: map["senderName"],
      receiverName: map["receiverName"],
    );
  }
}
