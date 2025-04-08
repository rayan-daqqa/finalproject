class checkLoginModel {
  String? result;
  String? fullName;




  checkLoginModel({
    this.result,
    this.fullName,


  });


  factory checkLoginModel.fromJson(Map<String, dynamic> json) {
    return checkLoginModel(
      result: json['result'],
      fullName: json['fullName'],


    );
  }

}
