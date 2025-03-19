

class MyReview{
  final String senderUid;
  final String senderName;
  final String receiverUid;
  final double rating;
  final String description;
  final int timeStamp;

  const MyReview({
    required this.senderUid,
    required this.senderName,
    required this.receiverUid,
    required this.rating,
    required this.description,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'senderName': senderName,
      'receiverUid': receiverUid,
      'rating': rating,
      'description': description,
      'timeStamp': timeStamp,
    };
  }

  factory MyReview.fromMap(Map<String, dynamic> map) {
    return MyReview(
      senderUid: map['senderUid'],
      senderName: map['senderName'],
      receiverUid: map['receiverUid'],
      rating: map['rating'],
      description: map['description'],
      timeStamp: map['timeStamp'],
    );
  }
}