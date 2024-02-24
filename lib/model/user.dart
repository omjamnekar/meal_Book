class UserDataManager {
  String? email;
  String? password;
  String? name;
  String? phone;

  UserDataManager({
    this.email,
    this.password,
    this.name,
    this.phone,
  });

  UserDataManager.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }

  @override
  String toString() {
    return 'User{email: $email, password: $password, name: $name, phone: $phone}';
  }
}
