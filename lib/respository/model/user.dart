import 'dart:io';

import 'package:uuid/uuid.dart';

class UserDataManager {
  String id = Uuid().v4();
  String? email;
  String? password;
  int? male;
  String? name;
  String? phone;
  String? image;

  UserDataManager(
    String id, {
    this.email,
    this.password,
    this.male,
    this.name,
    this.phone,
    this.image,
  });

  UserDataManager.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? Uuid().v4();
    email = json['email'] ?? '';
    male = json["male"] ?? 0;
    password = json['password'] ?? '';
    name = json['name'] ?? '';
    phone = json['phone'] ?? '';
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['male'] = this.male;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['image'] = this.image;

    return data;
  }

  // @override
  // String toString() {
  //   return 'User{  email: $email, password: $password, name: $name, phone: $phone , image: $image }';
  // }
}
