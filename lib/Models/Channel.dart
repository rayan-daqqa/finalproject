class Channel{
  Channel({
    this.channelID="",
    this.ImageURL="",
    this.channelName="",

  });
  String channelID;
  String channelName;
  String ImageURL;

  factory Channel. fromJson(Map<String, dynamic>json )=> Channel(
    channelID:json["channelID"],
    channelName:json["channelName"],
    ImageURL:json["ImageURL"],


  );
    Map< String, dynamic>tojson()=>{
      "ChannelID":channelID,
      "ChannelName":channelName,
      "ImageURL":ImageURL,
    };
}