class Channel{
  Channel({
    this.channelID=0,
    this.ImageURL="",
    this.channelName="",
    // this.channelLinks="",
    // this.categoryID=0,
  });

  int channelID;
  String channelName;
  String ImageURL;
  // String channelLinks;
  // int categoryID;

  factory Channel.fromJson(Map<String, dynamic>json )=> Channel(
    channelID:json["channelID"],
    channelName:json["channelName"],
    ImageURL:json["ImageURL"],
    // channelLinks:json["channelLinks"],
    // categoryID:json["categoryID"],

  );
    Map< String, dynamic>tojson()=>{
      "ChannelID":channelID,
      "ChannelName":channelName,
      "ImageURL":ImageURL,
      // "Links":channelLinks,
      // "categoryID":categoryID,
    };
}