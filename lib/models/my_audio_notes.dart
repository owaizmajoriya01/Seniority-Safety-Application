class MyAudioNotes {
  final String url;
  final String from;
  final String to;
  final String senderName;
  final String receiverName;
  final int timeStamp;
  final String? additionalNote;

  const MyAudioNotes({
    required this.url,
    required this.from,
    required this.to,
    required this.senderName,
    required this.receiverName,
    required this.timeStamp,
    this.additionalNote,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'from': from,
      'to': to,
      'senderName': senderName,
      'receiverName': receiverName,
      'timeStamp': timeStamp,
      'additionalNote': additionalNote,
    };
  }

  factory MyAudioNotes.fromMap(Map<String, dynamic> map) {
    return MyAudioNotes(
      url: map['url'],
      from: map['from'],
      to: map['to'],
      senderName: map['senderName'],
      receiverName: map['receiverName'],
      timeStamp: map['timeStamp'],
      additionalNote: map['additionalNote'],
    );
  }

  MyAudioNotes copyWith({
    String? url,
    String? from,
    String? to,
    String? senderName,
    String? receiverName,
    int? timeStamp,
    String? additionalNote,
  }) {
    return MyAudioNotes(
      url: url ?? this.url,
      from: from ?? this.from,
      to: to ?? this.to,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      timeStamp: timeStamp ?? this.timeStamp,
      additionalNote: additionalNote ?? this.additionalNote,
    );
  }
}
