import 'package:flash_chat/user.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("last_name", user.first_name);
    prefs.setString("first_name", user.first_name);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("password", user.password);
    prefs.setString("password_confirmation", user.password_confirmation);


    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String first_name = prefs.getString("first_name");
    String last_name = prefs.getString("last_name");
    String email = prefs.getString("email");
    String phone = prefs.getString("phone");
    String password = prefs.getString("password");
    String password_confirmation = prefs.getString("password_confirmation");


    return User(

        first_name: first_name,
        last_name: last_name,
        email: email,
        phone: phone,
        password: password,
        password_confirmation: password_confirmation,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    prefs.remove("first_name");
    prefs.remove("last_name");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("password");
    prefs.remove("password_confirmation");

  }

  /*Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("phone");
    return token;
  }*/
}