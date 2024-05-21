import 'dart:collection';

class User {
  final String uuid;
  String username;
  /*
  This LinkedHashMap will hold Song Titles (maybe some sort of unique ID instead?) as the keys of the map
  and then a String to hold the User's reviews for each song.
  */
  LinkedHashMap<String, String> reviews;

  User({
    required this.uuid,
    required this.username,
    required this.reviews,
  });
}