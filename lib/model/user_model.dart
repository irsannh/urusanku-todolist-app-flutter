class UserModel {
  String uid;
  String name;
  String email;
  String fcmToken;

  UserModel({required this.uid, required this.name, required this.email, required this.fcmToken});

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
    uid: uid,
    name: map['name'] ?? '',
    email: map['email'] ?? '',
        fcmToken: map['fcm_token'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'fcm_token': fcmToken
    };
  }
}