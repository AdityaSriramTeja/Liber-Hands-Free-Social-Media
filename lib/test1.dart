import 'dart:math';

import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_hackathon/feed.dart';
import 'package:twitter_hackathon/getTweets.dart';
import 'package:twitter_hackathon/static.dart';
import 'package:twitter_hackathon/tweet_database.dart';

import 'languagePreferences.dart';
import 'main.dart';

class LanguagePreferences extends StatefulWidget {
  static String defaultLanguage = 'en';
  static bool isHandsFreeSetting = true;
  final String? currentUserUID;
  final String? currentUserProfilePic;
  final String? currentUserName;
  final queries;

  const LanguagePreferences(
      {Key? key,
      required this.currentUserUID,
      required this.currentUserProfilePic,
      required this.currentUserName,
      required this.queries})
      : super(key: key);

  @override
  State<LanguagePreferences> createState() => _LanguagePreferencesState();
}

class _LanguagePreferencesState extends State<LanguagePreferences> {
  List<Color> gradient1 = [Color(0xFF043E49), Color(0xFF1E7879)];
  List<Color> gradient2 = [Colors.blueAccent, Colors.blue];
  List<Color> gradient3 = [Colors.deepPurple, Colors.purpleAccent];
  Map langKeys = StaticFile.langKeys;

  //Drop down languages
  List languagesDropDown = [];
  List handsFreeDropDown = ["Hands Free", "Hands-On"];
  String? language = "English";
  bool handsFree = LanguagePreferences.isHandsFreeSetting;
  checkValue(bool handsFree) {
    if (handsFree) {
      return "Hands Free";
    } else {
      return "Hands-On";
    }
  }

  @override
  void initState() {
    super.initState();
    langKeys.forEach((key, value) => languagesDropDown.add(key));
    languagesDropDown.sort();
    AlanVoice.removeButton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight, end: Alignment.bottomLeft,
              //For Properties for Radial Gradient
              // radius: 3.5,
              //center: Alignment.topRight,
              colors: gradient1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Liber',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: Opacity(
                      opacity: 0.81,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            'The Hands-Free',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Social Media',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'App:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: DropdownButton(
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
                          icon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.arrow_circle_down_outlined),
                          ),
                          iconEnabledColor: Colors.white,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          dropdownColor: Colors.white,
                          underline: Container(),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: DropdownButton(
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
                          icon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.arrow_circle_down_outlined),
                          ),
                          iconEnabledColor: Colors.white,
                          style: TextStyle(color: Colors.yellow, fontSize: 15),
                          dropdownColor: Colors.black,
                          underline: Container(),
                        ),
                      )),
                  SizedBox(height: 30),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Save',
                          style: TextStyle(color: Color(0xFF1E7879)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    onPressed: () async {
                      //Re-call the Twitter API and load up the tweets
                      GetTweets tweetController = GetTweets();
                      var tdObject = TweetsDatabase.instance;

                      //Delete all previous database data
                      await tdObject.deleteAll();
                      List<dynamic> queries = widget.queries;
                      print(
                          "===============================QUERIES FROM LANG PREF: ${queries}}==========================");
                      Random random = new Random();
                      int randomNumber = random.nextInt(4);
                      //Get new tweets from the API
                      var tweets = await tweetController
                          .getTweets(queries[randomNumber]);

                      var languageCode = langKeys[this.language];
                      LanguagePreferences.defaultLanguage = languageCode;

                      //Store tweets in database
                      await tweetController.storeTweetsinDB(
                          tweets, languageCode);
                      print("Language changed to ${languageCode}");

                      LanguagePreferences.isHandsFreeSetting = this.handsFree;
                      print("HandsFree:" + handsFree.toString());
                    },
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Feed',
                            style: TextStyle(color: Color(0xFF1E7879)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF1E7879),
                          ),
                        ],
                      ),
                      onPressed:
                          //Re-call the Twitter API and load up the tweets
                          showFeedScreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showFeedScreen() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserUID)
        .update({
      'hands_free': this.handsFree,
      'translation': langKeys[this.language],
    });
    //CHANGE: Delays the repaint by 1 second
    Future.delayed(Duration(seconds: 2), () {
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
                  isHandsFree: this.handsFree,
                  queries: widget.queries,
                )),
      );
    });
    //Navigator.pop;
  }
}
