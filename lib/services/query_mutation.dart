class QueryMutation {
  String getAllUsers(){
    return """ 
      {
        users {
          id
          email
        }
      }
    """;
  }

  String getUsers(String code){
    return """
      {
        user(email: "$code") {
          email
        }
      }
    """;
  }





//  String validateCodeSample() {
//    return """
//      {
//
//      }
//    """;
//  }



}