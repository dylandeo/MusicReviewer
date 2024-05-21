import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_junkie/buttons/settings_button.dart';
import 'package:music_junkie/buttons/profile_and_search_button.dart';
import 'package:music_junkie/musicBrainzAPI/mbAPIHelper.dart';
import 'package:music_junkie/pages/profile_page.dart';
import 'package:music_junkie/pages/song_page.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';
  Map<String, Map<String, String>> _searchResults = {};
  bool _noResults = false;
  bool darkModeInit = false;

  Future<void> _performSearch(String query) async {
    // Perform the search based on the query
    Map<String, Map<String, String>> results = await searchForArtistTracks(query);
    setState(() {
      _searchResults = results;
      _noResults = _searchResults.isEmpty;
    });
  }

  // void _navigateToResultPage(String title, String artistName, String trackID) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SongPage(title: title, artistName: artistName, trackID: trackID)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeInit ? const Color.fromARGB(255, 60, 216, 200) : Colors.white,
      appBar: AppBar(
        backgroundColor: darkModeInit ? const Color.fromARGB(255, 60, 216, 200) : Colors.white,
        automaticallyImplyLeading: false,
        title: Text('Search'),
        centerTitle: true,
        actions: [
          SettingsButton(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _performSearch(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter song title',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  String title = _searchResults.keys.elementAt(index);
                  String artistName = _searchResults[title]!['Artist']!;
                  String trackID = _searchResults[title]!['Track ID']!;
                  return ListTile(
                    title: Text('$title by $artistName'),
                    onTap: () async {
                    var url = Uri.https('mj-backend-api-7jy7nkqd4a-uc.a.run.app', '/songs/${trackID}/${title}/${artistName}');
                    await http.post(url);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SongPage(title: title, artistName: artistName, trackID: trackID)),);
                    }
                  );
                },
              ),
            ),
          if (_noResults)
            Text(
              'No results found for "$_searchQuery"!',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
      bottomNavigationBar: BottomButtons(
        musicButtonOnPressed: () {
          // No action needed for the music button in the search page
           Navigator.push(context, MaterialPageRoute(builder: ((context) => SearchPage())));
        },
        profileButtonOnPressed: () {
          // Navigate back to the profile page
          Navigator.push(context, MaterialPageRoute(builder: ((context) => ProfilePage())));
        },
      ),
    );
  }
}