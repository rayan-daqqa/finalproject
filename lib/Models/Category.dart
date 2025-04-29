class category {
  category({
    this.categoryID    = 0,
    this.categoryName = "",
    this.imageCat = "",

  });

  int categoryID   ;
  String categoryName;
  String imageCat;

  factory category.fromJson(Map<String, dynamic> json)=>
      category(
        categoryID: json ["categoryID"],
        categoryName: json["categoryName"],
        imageCat: json["imageCat"],

      );

  Map<String, dynamic> toJson() =>
      {
        "categoryID ":categoryID ,
        "categoryName":categoryName,
        "imageCat": imageCat,

      };
}