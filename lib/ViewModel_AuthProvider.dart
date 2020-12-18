import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flash_chat/ApiUrl.dart';
import 'package:flash_chat/UserPreferences.dart';
import 'package:flash_chat/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';


final String liveBaseURL = "http://3.131.4.14/api/v1/users/?user[email]=ra.sh.id.ra.mk@gmail.com&user"
    "[first_name]=rashed&user[last_name]=mehmood&user[phone]=945888944343&PushToken="
    "pushasdfasd4cwerqwecda4qrcadqd3der3rqwer33qe&user[password]=123456&user[password_confirmation]=123456";
enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  Status get registeredInStatus => _registeredInStatus;


  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'user': {
        'email': email,
        'password': password
      }
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      "http://3.131.4.14/api/v1/sessions?email=$email&password=$password",
      //body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 401) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      //var userData = responseData['data'];
      print("Response : ${response.body}");
      User authUser = User.fromJson(responseData);
      print("asdfghj");
      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
      print(authUser.email);
    } else {
      //print("${response.statusCode}");
      print("asdfghj");
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(String firstname, String lastname,
      String email, String phone, String password,
      String passwordConfirmation) async {
    final String base = "http://3.131.4.14/api/v1/users/?user[email]=$email&user"
        "[first_name]=$firstname&user[last_name]=$lastname&user[phone]=$phone&PushToken="
        "pushasdfasd4cwerqwecda4qrcadqd3der3rqwer33qe&user[password]=$password&user[password_confirmation]=$passwordConfirmation";
    final Map<String, dynamic> registrationData = {
      'user': {
        'first_name': firstname,
        'last_name': lastname,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation
      }
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();
    return await post(base,
        //body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);
    //print("Response status: ${response.statusCode}");
    print("Response : ${response.body}");
    if (response.statusCode == 201) {

      //var userData = responseData[];

      User authUser = User.fromJson(responseData);

      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

}