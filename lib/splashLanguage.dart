import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_hackathon/feed.dart';
import 'package:twitter_hackathon/getTweets.dart';
import 'package:twitter_hackathon/languagePreferences.dart';
import 'package:twitter_hackathon/tweet_database.dart';

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
            Future.delayed(const Duration(seconds: 2), () {
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
  bool handsFree = false;

  @override
  void initState() {
    super.initState();
    langKeys.forEach((key, value) => languagesDropDown.add(key));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Twitter Hands Free",
            style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Container(
              height: 50,
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            const Text("Developed by Teja and Shreyas")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: showFeedScreen,
          child: const Icon(Icons.arrow_forward_ios_outlined)),
    );
  }

  //Display the feed screen
  void showFeedScreen() async {
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

    LanguagePreferences.isHandsFreeSetting = handsFree;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserUID)
        .set({
      'uid': widget.currentUserUID,
      'profile_pic': widget.currentUserProfilePic,
      'name': widget.currentUserName,
      'new_user': false,
      'hands_free': handsFree,
      'translation': LanguagePreferences.defaultLanguage,
    });

    //CHANGE: Delays the repaint by 1 second
    Future.delayed(const Duration(seconds: 2), () {
      //Move to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Feed(
                  isSearchFeed: false,
                  searchTweets: null,
                  isLogoutAllowed: true,
                  isHandsFree: handsFree,
                  currentUserName: widget.currentUserName,
                  currentUserUID: widget.currentUserUID,
                  currentUserProfilePic: widget.currentUserProfilePic,
                )),
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
