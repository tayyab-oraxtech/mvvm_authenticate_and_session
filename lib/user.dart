/*class User {
  String email;
  String first_name;
  String last_name;
  String phone;
  String PushToken;
  String password;


  User({this.email, this.first_name, this.last_name, this.phone, this.PushToken,
      this.password});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        email: responseData['email'],
        first_name: responseData['first_name'],
        last_name: responseData['last_name'],
        phone: responseData['phone'],
        PushToken: responseData['PushToken'],
         password: responseData['password'],
    );
  }
}*/
class User {
  String first_name;
  String last_name;
  String email;
  String phone;
  String password ;
  String password_confirmation;


  User({this.first_name, this.last_name, this.email, this.phone, this.password,
      this.password_confirmation});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        first_name: responseData['first_name'],
        last_name: responseData['last_name'],
        email: responseData['email'],
        phone: responseData['phone'],
        password: responseData['password'],
        password_confirmation: responseData['password_confirmation'],

    );
  }
}