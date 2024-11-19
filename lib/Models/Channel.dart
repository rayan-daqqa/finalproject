class Channel{
  Channel({
    this.ChannelID="",
    this.ChannelName="",


  });
  String ChannelID;
  String ChannelName;

  factory Channel. fromJson(Map<String, dynamic>json )=> Channel(
    ChannelID:json["ChannelID"],
    ChannelName:json["ChannelName"],


  );
    Map< String, dynamic>tojson()=>{
      "ChannelID":ChannelID,
      "ChannelName":ChannelName,

    };
}