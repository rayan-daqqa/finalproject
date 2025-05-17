class checkLoginModel {
  String? userID;
  String? fullName;


  checkLoginModel({
    this.userID,
    this.fullName,


  });


  // {"userID":17,"firstName":"mohmad","lastName":"majadly"}


  factory checkLoginModel.fromJson(Map<String, dynamic> json) {
    return checkLoginModel(
      userID: json['userID'],
      fullName: json['fullName'],



    );
  }

}
