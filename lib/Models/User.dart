class User{
  User({
    this.Password="",
    this.firstName="",
    this.lastName="",
    this. userID="",

  });
  String Password;
  String firstName;
  String lastName;
  String userID;

  factory User. fromJson(Map<String, dynamic>json )=> User(
    Password:json["Password"],
    firstName:json["firstName"],
    lastName:json["lastName"],
    userID:json["userID"],

  );
    Map< String, dynamic>tojson()=>{
      "Password":Password,
      "firstName":firstName,
      "lastName":lastName,
      "userID":userID,
    };
}