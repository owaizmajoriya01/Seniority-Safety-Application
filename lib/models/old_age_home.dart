class OldAgeHome {
  final String uid;
  final String name;
  final String description;
  final String contactNumber;
  final String email;
  final String address;

  const OldAgeHome({
    required this.uid,
    required this.name,
    required this.description,
    required this.contactNumber,
    required this.email,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
    };
  }

  factory OldAgeHome.fromMap(Map<String, dynamic> map) {
    return OldAgeHome(
      uid: map['uid'] ?? "",
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      contactNumber: map['contactNumber'] ?? "",
      email: map['email'] ?? "",
      address: map['address'] ?? "",
    );
  }

  OldAgeHome copyWith({
    String? uid,
    String? name,
    String? description,
    String? contactNumber,
    String? email,
    String? address,
  }) {
    return OldAgeHome(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        description: description ?? this.description,
        contactNumber: contactNumber ?? this.contactNumber,
        email: email ?? this.email,
        address: address ?? this.address);
  }

  @override
  String toString() => name;
}
