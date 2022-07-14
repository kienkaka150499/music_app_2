class Song {
  int id;
  String name;
  String singer;
  String imageURL;
  bool favorite = false;
  int time;
  String source;

  Song(
      {required this.id,
      required this.name,
      required this.singer,
      required this.imageURL,
      required this.time,
      favorite = false,
      required this.source});
}
