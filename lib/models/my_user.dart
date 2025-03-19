import 'package:collection/collection.dart';

enum UserRoleEnum { elder, caretaker, admin }

class MyUser {
  final String? uid;
  final String? name;
  final String? gender;
  final String? email;
  final String? mobile;
  final String? dateOfBirth;
  final String? address;
  final String? role;
  final num? lastLat;
  final num? lastLong;
  final String? deviceToken;
  final String? imageUrl;
  final bool isEnabled;
  final String? assignedOldAge;

  const MyUser({
    required this.uid,
    required this.name,
    required this.gender,
    required this.email,
    required this.mobile,
    required this.dateOfBirth,
    required this.address,
    required this.role,
    required this.lastLat,
    required this.lastLong,
    required this.deviceToken,
    required this.imageUrl,
    this.assignedOldAge,
    this.isEnabled = true,
  });

  int get calculateAge {
    if (dateOfBirth == null) return 0;
    try {
      DateTime today = DateTime.now();
      DateTime dateOfBirth = DateTime.parse(this.dateOfBirth!);

      int age = today.year - dateOfBirth.year;
      if (today.month < dateOfBirth.month || (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  UserRoleEnum roleStringToEnum() {
    var result = UserRoleEnum.values.firstWhereOrNull((element) => element.name == role);
    return result ?? UserRoleEnum.elder;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'gender': gender,
      'email': email,
      'mobile': mobile,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'role': role,
      'lastLat': lastLat,
      'lastLong': lastLong,
      'deviceToken': deviceToken,
      'imageUrl': imageUrl,
      "isEnabled": isEnabled,
      "assignedOldAge": assignedOldAge,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
        uid: map['uid'] ?? "",
        name: map['name'] ?? "",
        gender: map['gender'] ?? "",
        email: map['email'] ?? "",
        mobile: map['mobile'] ?? "",
        dateOfBirth: map['dateOfBirth'] ?? "",
        address: map['address'] ?? "",
        role: map['role'] ?? "",
        lastLat: map['lastLat'] ?? 0.0,
        lastLong: map['lastLong'] ?? 0.0,
        deviceToken: map['deviceToken'] ?? "",
        imageUrl: map['imageUrl'] ?? "",
        isEnabled: map['isEnabled'] ?? true,
        assignedOldAge: map['assignedOldAge'] ?? "");
  }

  MyUser copyWith({
    String? uid,
    String? name,
    String? gender,
    String? email,
    String? mobile,
    String? dateOfBirth,
    String? address,
    String? role,
    double? lastLat,
    double? lastLong,
    String? deviceToken,
    String? imageUrl,
    bool? isEnabled,
    String? assignedOldAge,
  }) {
    return MyUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      role: role ?? this.role,
      lastLat: lastLat ?? this.lastLat,
      lastLong: lastLong ?? this.lastLong,
      deviceToken: deviceToken ?? this.deviceToken,
      imageUrl: imageUrl ?? this.imageUrl,
      isEnabled: isEnabled ?? this.isEnabled,
      assignedOldAge: assignedOldAge ?? this.assignedOldAge,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyUser && runtimeType == other.runtimeType && uid == other.uid && isEnabled == other.isEnabled;

  @override
  int get hashCode => uid.hashCode ^ isEnabled.hashCode;
}

///------------------------------------------------------------------------------------

class DummyUser {
  DummyUser({
    this.results,
    this.info,
  });

  final List<Result>? results;
  final Info? info;

  factory DummyUser.fromJson(Map<String, dynamic> json) => DummyUser(
        results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
        info: json["info"] == null ? null : Info.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "info": info?.toJson(),
      };
}

class Info {
  Info({
    this.seed,
    this.results,
    this.page,
    this.version,
  });

  final String? seed;
  final int? results;
  final int? page;
  final String? version;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        seed: json["seed"],
        results: json["results"],
        page: json["page"],
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "seed": seed,
        "results": results,
        "page": page,
        "version": version,
      };
}

class Result {
  Result({
    this.gender,
    this.name,
    this.location,
    this.email,
    this.login,
    this.dob,
    this.registered,
    this.phone,
    this.cell,
    this.id,
    this.picture,
    this.nat,
  });

  final String? gender;
  final Name? name;
  final Location? location;
  final String? email;
  final Login? login;
  final Dob? dob;
  final Dob? registered;
  final String? phone;
  final String? cell;
  final Id? id;
  final Picture? picture;
  final String? nat;

  String get formattedMobileNumber => "9${cell?.replaceAll("-", "")}";

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        gender: json["gender"],
        name: json["name"] == null ? null : Name.fromJson(json["name"]),
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        email: json["email"],
        login: json["login"] == null ? null : Login.fromJson(json["login"]),
        dob: json["dob"] == null ? null : Dob.fromJson(json["dob"]),
        registered: json["registered"] == null ? null : Dob.fromJson(json["registered"]),
        phone: json["phone"],
        cell: json["cell"],
        id: json["id"] == null ? null : Id.fromJson(json["id"]),
        picture: json["picture"] == null ? null : Picture.fromJson(json["picture"]),
        nat: json["nat"],
      );

  Map<String, dynamic> toJson() => {
        "gender": gender,
        "name": name?.toJson(),
        "location": location?.toJson(),
        "email": email,
        "login": login?.toJson(),
        "dob": dob?.toJson(),
        "registered": registered?.toJson(),
        "phone": phone,
        "cell": cell,
        "id": id?.toJson(),
        "picture": picture?.toJson(),
        "nat": nat,
      };
}

class Dob {
  Dob({
    this.date,
    this.age,
  });

  final DateTime? date;
  final int? age;

  factory Dob.fromJson(Map<String, dynamic> json) => Dob(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "age": age,
      };
}

class Id {
  Id({
    this.name,
    this.value,
  });

  final String? name;
  final String? value;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}

class Location {
  Location({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.coordinates,
    this.timezone,
  });

  final Street? street;
  final String? city;
  final String? state;
  final String? country;
  final String? postcode;
  final Coordinates? coordinates;
  final Timezone? timezone;

  String get fullAddress => "${street?.name}, $city, $state, $country $postcode";

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        street: json["street"] == null ? null : Street.fromJson(json["street"]),
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postcode: json["postcode"].toString(),
        coordinates: json["coordinates"] == null ? null : Coordinates.fromJson(json["coordinates"]),
        timezone: json["timezone"] == null ? null : Timezone.fromJson(json["timezone"]),
      );

  Map<String, dynamic> toJson() => {
        "street": street?.toJson(),
        "city": city,
        "state": state,
        "country": country,
        "postcode": postcode,
        "coordinates": coordinates?.toJson(),
        "timezone": timezone?.toJson(),
      };
}

class Coordinates {
  Coordinates({
    this.latitude,
    this.longitude,
  });

  final String? latitude;
  final String? longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Street {
  Street({
    this.number,
    this.name,
  });

  final int? number;
  final String? name;

  factory Street.fromJson(Map<String, dynamic> json) => Street(
        number: json["number"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
      };
}

class Timezone {
  Timezone({
    this.offset,
    this.description,
  });

  final String? offset;
  final String? description;

  factory Timezone.fromJson(Map<String, dynamic> json) => Timezone(
        offset: json["offset"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "description": description,
      };
}

class Login {
  Login({
    this.uuid,
    this.username,
    this.password,
    this.salt,
    this.md5,
    this.sha1,
    this.sha256,
  });

  final String? uuid;
  final String? username;
  final String? password;
  final String? salt;
  final String? md5;
  final String? sha1;
  final String? sha256;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        uuid: json["uuid"],
        username: json["username"],
        password: json["password"],
        salt: json["salt"],
        md5: json["md5"],
        sha1: json["sha1"],
        sha256: json["sha256"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "username": username,
        "password": password,
        "salt": salt,
        "md5": md5,
        "sha1": sha1,
        "sha256": sha256,
      };
}

class Name {
  Name({
    this.title,
    this.first,
    this.last,
  });

  final String? title;
  final String? first;
  final String? last;

  String get fullName => "$first $last";

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        title: json["title"],
        first: json["first"],
        last: json["last"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "first": first,
        "last": last,
      };
}

class Picture {
  Picture({
    this.large,
    this.medium,
    this.thumbnail,
  });

  final String? large;
  final String? medium;
  final String? thumbnail;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        large: json["large"],
        medium: json["medium"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "large": large,
        "medium": medium,
        "thumbnail": thumbnail,
      };
}
