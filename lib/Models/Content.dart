class Content {
  Content({
    this.contentID= 0,
    this.title = "",
    this.content = "",
    this.channelID = 0,
    this.link = "",

  });

  int contentID;
  int channelID;
  String title;
  String content;
  String link;


  factory Content.fromJson(Map<String, dynamic> json)=> Content(
        contentID: json["contentID"],
        channelID: json["channelID"],
        title: json["title"],
        content: json["content"],
        link: json["link"],
  );


  Map<String, dynamic> toJson() =>
      {
        "contentID ":contentID ,
        "title":title,
        "content": content,
        "channelID": channelID,
        "link": link,


      };
}