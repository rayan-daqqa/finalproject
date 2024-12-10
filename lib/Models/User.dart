class User{
  User({
    this.Password="",
    this.firstName="",
    this.lastName="",
    this.userID="",
    this.email="",

  });
  String Password;
  String firstName;
  String lastName;
  String userID;
  String email;


  factory User. fromJson(Map<String, dynamic>json )=> User(
    Password:json["Password"],
    firstName:json["firstName"],
    lastName:json["lastName"],
    userID:json["userID"],
    email:json["email"],


  );
    Map< String, dynamic>tojson()=>{
      "Password":Password,
      "firstName":firstName,
      "lastName":lastName,
      "userID":userID,
      "email":email,

    };
}