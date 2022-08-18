import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_hackathon/feed.dart';
import 'package:twitter_hackathon/getTweets.dart';
import 'package:twitter_hackathon/tweet_database.dart';

import 'languagePreferences.dart';

class LanguagePreferences extends StatefulWidget {
  static String defaultLanguage = 'en';
  static bool isHandsFreeSetting = true;
  final String? currentUserUID;
  final String? currentUserProfilePic;
  final String? currentUserName;

  const LanguagePreferences(
      {Key? key,
      required this.currentUserUID,
      required this.currentUserProfilePic,
      required this.currentUserName})
      : super(key: key);

  @override
  State<LanguagePreferences> createState() => _LanguagePreferencesState();
}

class _LanguagePreferencesState extends State<LanguagePreferences> {
  Map langKeys = {
    "English": "en",
    "Hindi": "hi",
    "Telugu": "te",
    "Spanish": "es",
  };

  //Drop down languages
  List languagesDropDown = [];
  List handsFreeDropDown = ["Hands Free", "Hands-On"];
  String? language = "English";
  bool handsFree = LanguagePreferences.isHandsFreeSetting;

  @override
  void initState() {
    super.initState();
    langKeys.forEach((key, value) => languagesDropDown.add(key));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DropdownButton(
              value: this.language,
              onChanged: (value) {
                setState(() {
                  this.language = value as String?;
                });
              },
              items: languagesDropDown.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
            DropdownButton(
              value: checkValue(this.handsFree),
              onChanged: (value) {
                if (value.toString() == "Hands-On") {
                  setState(() {
                    handsFree = false;
                  });
                }
                if (value.toString() == "Hands Free") {
                  setState(() {
                    handsFree = true;
                  });
                }
              },
              items: handsFreeDropDown.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () async {
                //Re-call the Twitter API and load up the tweets
                GetTweets tweetController = GetTweets();
                var tdObject = TweetsDatabase.instance;

                //Delete all previous database data
                await tdObject.deleteAll();

                //Get new tweets from the API
                var tweets = await tweetController.getTweets("twitterdev");

                var languageCode = langKeys[this.language];
                LanguagePreferences.defaultLanguage = languageCode;

                //Store tweets in database
                await tweetController.storeTweetsinDB(tweets, languageCode);
                print("Language changed to ${languageCode}");

                LanguagePreferences.isHandsFreeSetting = this.handsFree;
                print("HandsFree:" + handsFree.toString());
              },
              child: const Text("Save Settings"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: showFeedScreen, child: const Icon(Icons.home)),
    );
  }

  //Display the feed screen
  void showFeedScreen() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserUID)
        .set({
      'UID': widget.currentUserUID,
      'profile_pic': widget.currentUserProfilePic,
      'name': widget.currentUserName,
      'new_user': false,
      'hands_free': this.handsFree,
      'translation': LanguagePreferences.defaultLanguage,
    });
    //CHANGE: Delays the repaint by 1 second
    Future.delayed(Duration(seconds: 1), () {
      //Move to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Feed(
                currentUserName: widget.currentUserName,
                currentUserUID: widget.currentUserUID,
                currentUserProfilePic: widget.currentUserProfilePic,
                isSearchFeed: false,
                searchTweets: null,
                isLogoutAllowed: true,
                isHandsFree: this.handsFree)),
      );
    });
    Navigator.pop;
  }

  checkValue(bool handsFree) {
    if (handsFree) {
      return "Hands Free";
    } else {
      return "Hands-On";
    }
  }
}
