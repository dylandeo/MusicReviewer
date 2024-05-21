import 'dart:convert';

import 'package:http/http.dart' as http;

const String SEARCH_URL = "http://musicbrainz.org/ws/2/release/?query=releases:";

Future<Map<String, Map<String, String>>> searchForArtistTracks(String trackName) async{
  final Map<String, Map<String, String>> foundTracks = {};
  trackName = trackName.replaceAll( " ", "%20");
  final response = await http.get(Uri.parse(SEARCH_URL + trackName + "&fmt=json"));
  if(response.statusCode == 200){
    var result = jsonDecode(response.body) as Map<String, dynamic>;
    //var counter = 0;
    for(var entry in result["releases"]){
      if(foundTracks.length >= 5){
        break;
      }
      if(entry["title"] != null && entry["title"] != 'Releases'){
         foundTracks[entry["title"]] = {
           "Artist" : entry["artist-credit"][0]["name"],
           "Track ID": entry["id"],
         };
      }
    }
  }
  return foundTracks;
}

/*
void main() async {
  Map<String, Map<String, String>> test = await searchForArtistTracks("Night Lovell");
  print(test);
}
*/