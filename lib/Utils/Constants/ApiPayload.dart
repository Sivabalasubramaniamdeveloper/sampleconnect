class ApiPayload{
  static Map<String,dynamic>loginPayload(userName,Password,keepMeSignIn)=>{ "username"
      : userName,
    "password": Password,
    "keepMeSignIn":keepMeSignIn };
}