class AdminModel {
  final String uid;
  final String name;
  final String email;

  AdminModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  factory AdminModel.fromMap(
      Map<String, dynamic> map,
      String uid,
      ) {
    return AdminModel(
      uid: uid,
      name: map["name"]?.toString() ?? "",
      email: map["email"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
    };
  }
}