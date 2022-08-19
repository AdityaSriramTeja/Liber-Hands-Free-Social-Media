import 'dart:collection';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twitter_hackathon/feed.dart';
import 'package:twitter_hackathon/getTweets.dart';
import 'package:twitter_hackathon/helpAndSupport.dart';
import 'package:twitter_hackathon/languagePreferences.dart';
import 'package:twitter_hackathon/main.dart';
import 'package:twitter_hackathon/static.dart';

import 'package:twitter_hackathon/tweet_database.dart';

import 'onboarding.dart';

class SplashLanguage extends StatelessWidget {
  const SplashLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    User? currentUser = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          FirebaseAuth firebaseAuth = FirebaseAuth.instance;
          firebaseAuth.signOut();
        }

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data!.exists) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['new_user'] == true) {
            print("WOW THIS IS A NEW USER: FROM SPLASH");
            return SplashScreenContent(
              currentUserUID: currentUser!.uid,
              currentUserName: currentUser.displayName,
              currentUserProfilePic: currentUser.photoURL,
            );
          } else if (data['new_user'] == false) {
            print("THIS IS AN OLD USER: FROM SPLASH");
            //   CircularProgressIndicator;
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Feed(
                      isSearchFeed: false,
                      searchTweets: null,
                      isLogoutAllowed: true,
                      isHandsFree: data['hands_free'],
                      currentUserUID: currentUser!.uid,
                      currentUserProfilePic: currentUser.photoURL,
                      currentUserName: currentUser.displayName,
                      queries: data['search_query'],
                    );
                  },
                ),
              );
            });
            // Prints after 1 second.

          }
        }

        return const Center(child: Text("loading"));
      },
    );
  }
}

class SplashScreenContent extends StatefulWidget {
  final String? currentUserUID;
  final String? currentUserProfilePic;
  final String? currentUserName;
  const SplashScreenContent({
    Key? key,
    required this.currentUserUID,
    required this.currentUserProfilePic,
    required this.currentUserName,
  }) : super(key: key);

  @override
  State<SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<SplashScreenContent> {
  Map langKeys = StaticFile.langKeys;

  //Drop down languages
  List languagesDropDown = [];
  List handsFreeDropDown = ["Hands Free", "Hands-On"];
  String? language = "English";
  bool handsFree = LanguagePreferences.isHandsFreeSetting;

  late List<Query> _queries;
  late List<String> _filters;
  @override
  void initState() {
    super.initState();
    langKeys.forEach((key, value) => languagesDropDown.add(key));

    _filters = <String>[];
    _queries = <Query>[
      const Query('twitterdev'),
      const Query('programming'),
      const Query('sports'),
      const Query('kpop'),
      const Query('music'),
      const Query('movies'),
      const Query('nature'),
      const Query('health'),
      const Query('gym'),
      const Query('development'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Welcome to Liber: The Hands-Free Social Media",
                style:
                    GoogleFonts.bebasNeue(textStyle: TextStyle(fontSize: 18))),
            Text("Select topics you want to see",
                style:
                    GoogleFonts.bebasNeue(textStyle: TextStyle(fontSize: 18))),
            Wrap(
              children: queryWidgets.toList(),
            ),
            Column(
              children: [
                Text("Translate tweets to",
                    style: GoogleFonts.bebasNeue(
                        textStyle: TextStyle(fontSize: 15))),
                SizedBox(height: 20),
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
                  height: 10,
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
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: showOnboardingScreen,
          child: const Icon(Icons.arrow_forward_ios_outlined)),
    );
  }

  Iterable<Widget> get queryWidgets sync* {
    for (Query query in _queries) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          avatar: CircleAvatar(
            child: Text(query.name[0].toUpperCase()),
          ),
          label: Text(query.name),
          selected: _filters.contains(query.name),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _filters.add(query.name);
              } else {
                _filters.removeWhere((String name) {
                  return name == query.name;
                });
              }
            });
          },
        ),
      );
    }
  }

  //Display the feed screen
  void showOnboardingScreen() async {
    var languageCode = langKeys[this.language];
    LanguagePreferences.defaultLanguage = languageCode;

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
      'search_query': _filters,
    });

    //Re-call the Twitter API and load up the tweets
    GetTweets tweetController = GetTweets();
    var tdObject = TweetsDatabase.instance;

    //Delete all previous database data
    await tdObject.deleteAll();
    List<dynamic> queries = _filters;
    MainPage.searchQuery = _filters;
    print(
        "===============================QUERIES: ${queries}}==========================");
    // List randomList = [0, 1, 2, 3];
    // randomList.shuffle();
    // var tweets;
    // for (int i = 0; i < 4; i++) {
    //   tweets = await tweetController.getTweets(queries[randomList[i]]);
    //   await tweetController.storeTweetsinDB(tweets, languageCode);
    // }

    Random random = new Random();
    int randomNumber = random.nextInt(queries.length);

    //Get new tweets from the API
    var tweets = await tweetController.getTweets(queries[randomNumber]);

    //Store tweets in database
    await tweetController.storeTweetsinDB(tweets, languageCode);
    print("Language changed to ${languageCode}");

    LanguagePreferences.isHandsFreeSetting = handsFree;

    //CHANGE: Delays the repaint by 1 second
    Future.delayed(const Duration(seconds: 2), () {
      //Move to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnBoarding(
            isSetup: true,
            isHandFree: handsFree,
            currentUserProfilePic: widget.currentUserProfilePic,
            currentUserUID: widget.currentUserUID,
            currentUsername: widget.currentUserName,
            queries: _filters,
          ),
          // Feed(
          //   isSearchFeed: false,
          //   searchTweets: null,
          //   isLogoutAllowed: true,
          //   isHandsFree: handsFree,
          //   currentUserName: widget.currentUserName,
          //   currentUserUID: widget.currentUserUID,
          //   currentUserProfilePic: widget.currentUserProfilePic,
          // ),
        ),
      );
    });
    //Navigator.pop;
  }

  checkValue(bool handsFree) {
    if (handsFree) {
      return "Hands Free";
    } else {
      return "Hands-On";
    }
  }
}

class Query {
  const Query(this.name);
  final String name;
}

class Stack<E> {
  final _list = <E>[];

  void push(E value) => _list.add(value);

  E pop() => _list.removeLast();

  E get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();
}
