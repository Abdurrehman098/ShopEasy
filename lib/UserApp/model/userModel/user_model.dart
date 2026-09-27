import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  String id, name , email , phone ;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
});

  factory UserModel.fromMap(Map<String , dynamic>map){
    return UserModel(id: map["id"]?? "", name:map["name"]?? "", email:map["email"]?? "", phone: map["phone"]?? "", createdAt:(map["createdAt"] as Timestamp).toDate());


  }


  Map<String ,dynamic> toMap(){
    return{
      "id" : id,
      "name": name,
      "email" : email,
      "phone" :phone,
      "createdAt" : FieldValue.serverTimestamp(),

    };
  }

}