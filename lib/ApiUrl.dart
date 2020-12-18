class AppUrl {
  static const String liveBaseURL = "http://3.131.4.14/api/v1";
  static const String localBaseURL = "http://10.0.2.2:4000/api/v1";

  static const String baseURL = liveBaseURL;
  //static const String login = baseURL + "/session";  http://3.131.4.14/api/v1/sessions
  static const String login = "http://3.131.4.14/api/v1/sessions?email=rashed123@gmail.com&password=123456";
  static const String register = liveBaseURL + "/users/";
  static const String forgotPassword = baseURL + "/forgot-password";
}