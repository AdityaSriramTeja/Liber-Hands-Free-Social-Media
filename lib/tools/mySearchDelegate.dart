import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:twitter_hackathon/getTweets.dart';
import 'package:twitter_hackathon/languagePreferences.dart';
import 'package:twitter_hackathon/main.dart';

import '../feed.dart';
import '../model/note.dart';

class MySearchDelegate extends SearchDelegate {
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<String> searchResults = [
    'flutter',
    'gamedev',
    'youtube',
    'blackpink',
    'rihanna',
    'toronto',
    'marvel',
    'entertainment',
    'montreal',
    'wonderland',
    'gym'
  ];
  String finalTranslation;
  bool isHandsFree;
  MySearchDelegate(this.finalTranslation, this.isHandsFree);
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget buildResults(BuildContext context) {
    //updateSearch();
    // Future.delayed(Duration(seconds: 1), () {
    //   return const CircularProgressIndicator();
    // });
    String searchResult = query;
    query = '';
    return FutureBuilder(
        future: getUpdatedTweets(searchResult),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var tweets = snapshot.data as List<Note>;
            return Feed(
              isSearchFeed: true,
              searchTweets: tweets,
              isLogoutAllowed: true,
              isHandsFree: isHandsFree,
              currentUserUID: currentUser!.uid,
              currentUserName: currentUser!.displayName,
              currentUserProfilePic: currentUser!.photoURL,
              queries: MainPage.searchQuery,
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Text("Woops! There is an error while fetching data"));
          } else if (snapshot.connectionState != ConnectionState.done) {
            // some logic... and the following UI:
            return const Center(
                child: Text("Fetching data and translating..."));
          }
          return const Center(child: Text("Connected to API"));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //TODO make suggestions dynamic
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context);
            },
          );
        });
  }

  Future<List<Note>> getUpdatedTweets(String query) async {
    GetTweets obj = GetTweets();

    //final translator = GoogleTranslator();
    var tweets = await obj.getTweets(query);

    List<Note> listOfTweets = [];
    //Future.delayed(const Duration(milliseconds: 2), () async {
    for (int i = 0; i < tweets.data.length; i++) {
      String data = tweets.data[i].text;
      String twitter_username = "";
      await obj.twitter.usersService
          .lookupById(userId: tweets.data[i].authorId!)
          .then((value) {
        twitter_username = value.data.username;
      });
      print("TWITTER USERNAME:" + twitter_username);

      //var translatedText = await data.translate(to: finalTranslation);

      data.translate(to: LanguagePreferences.defaultLanguage).then((value) {
        listOfTweets.add(Note(
            id: i,
            isImportant: true,
            number: 1,
            title: twitter_username,
            description: tweets.data[i].text,
            translated: value.text));
      });
    }
    //});

    return listOfTweets;
  }
}
