import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:onboarding/onboarding.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:twitter_hackathon/getTweets.dart';
import 'package:twitter_hackathon/languagePreferences.dart';
import 'package:twitter_hackathon/tools/mySearchDelegate.dart';
import 'package:twitter_hackathon/tweet.dart';
import 'package:twitter_hackathon/tweet_database.dart';
import 'package:twitter_hackathon/model/note.dart';
import 'package:alan_voice/alan_voice.dart';

import 'helpAndSupport.dart';
import 'main.dart';
import 'onboarding.dart';

// ignore: slash_for_doc_comments
/**
API Key: h9reOghMaBCMqgmweFC0bEhTn
API Key Secret: f1R5NwzQc8IZsJekSK4gAbbEQPhta7KiNulhedRgMNOMIf469q
Bearer Token: AAAAAAAAAAAAAAAAAAAAAGIKeQEAAAAAky1uYF9dmm%2F0NcyliUMSrMxPLkw%3DuscOS7DjPvMKCqnxYBAMn8dA7rU7sMD3UVEO7JN3tUSOpcpZGm
Access Token: 1541909837352763392-g8NvGiRKShk5cIZrxlxnrDH56TYZae
Access Token Secret: sFjLxWdFFyvWewPq1BWkZYFV6WKxhUHZgK5rtjIQthcVW
 */

class Feed extends StatefulWidget {
  //State Properties
  final bool isSearchFeed;
  var searchTweets;
  bool isLogoutAllowed;
  bool isHandsFree;
  final String? currentUserUID;
  final String? currentUserProfilePic;
  final String? currentUserName;
  //Constructor
  Feed(
      {Key? key,
      required this.isSearchFeed,
      required this.searchTweets,
      required this.isLogoutAllowed,
      required this.isHandsFree,
      required this.currentUserUID,
      required this.currentUserProfilePic,
      required this.currentUserName})
      : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final itemController = ItemScrollController();
  GetTweets tweetController = GetTweets();
  var tdObject = TweetsDatabase.instance;
  FlutterTts flutterTts = FlutterTts();
  bool pause = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  ScrollController scrollController = ScrollController();
  //bool scroll = true;
  int counter = 0;
  bool _speechEnabled = true;
  String _lastWords = '';
  //String profilePic =
  // "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80";
  //String? username = user!.displayName;
  var tweets;
  final SpeechToText _speechToText = SpeechToText();
  String finalTranslation = '';
  bool forceSpeak = false;
  @override
  void initState() {
    super.initState();
    print("=====FEED IS INIT====");
    getTranslateValue();
    if (widget.isHandsFree) {
      // _initSpeech();
      setupAlan();
      AlanVoice.activate();
      print("widget is handsfree");
      setState(() {
        forceSpeak = true;
      });
    }
    pause = false;
    if (widget.isHandsFree) {
      stopSpeechHandsFree();
    } else {
      stopSpeech();
    }

    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _startScrollingTweetsHandsFree());
    //_startScrollingTweetsHandsFree();
  }

  @override
  void dispose() async {
    super.dispose();
    print("THIS SCREEN IS BEING DISPOSED");
    await flutterTts.stop();
    pause = !pause;
    await tdObject.deleteAll();
    AlanVoice.removeButton();
    //Re-call the Twitter API and load up the tweets
    var tweets = await tweetController.getTweets("twitterdev");

    //Store tweets in database
    tweetController.storeTweetsinDB(tweets, finalTranslation);
  }

  @override
  Widget build(BuildContext context) {
    //_startListening;
    AppBar? appBarFeedScreen;
    Widget feedBody;
    Widget? bottomNavBar;

    //If the feed widget is displayed when searching
    if (widget.isSearchFeed) {
      appBarFeedScreen = null;
      feedBody = searchFeedBuilder(widget.searchTweets);
    }

    //If the feed widget is displayed normally
    else {
      appBarFeedScreen = AppBar(
        title: const Center(child: Icon(LineAwesomeIcons.twitter)),
        backgroundColor: forceSpeak ? Colors.black : Colors.amber,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                stopSpeech();
                showSearch(
                  context: context,
                  delegate:
                      MySearchDelegate(finalTranslation, widget.isHandsFree),
                );
              },
              icon: const Icon(Icons.search)),
        ],
      );

      feedBody = homeFeedBuilder();
    }
    if (widget.isHandsFree) {
      //speechLogic();
      //  bottomNavBar = null;
    } else {
      bottomNavBar = FloatingActionButton(
        onPressed: () {
          print("PRESSED THE PAUSE?RESUME BUTTON");
          speechTracker();
        },
        child: pause
            ? const Icon(Icons.play_arrow_rounded)
            : const Icon(Icons.pause),
      );
    }

    return Scaffold(
        appBar: appBarFeedScreen,
        drawer: drawerWidget(context),
        body: feedBody,
        floatingActionButton: widget.isHandsFree
            ?
            // ? forceSpeak
            //     ? FloatingActionButton(
            //         onPressed: () {
            //           _initSpeech();
            //           print("I TURNED ON THE MIC");
            //           setState(() {
            //             forceSpeak = !forceSpeak;
            //           });
            //         },
            //         child: const Icon(Icons.  mic_off_outlined))
            //     : FloatingActionButton(
            //         onPressed: () {
            //           _speechToText.stop();
            //           print("I TURNED OFF THE MIC");
            //           setState(() {
            //             forceSpeak = !forceSpeak;
            //           });
            //         },
            //         child: const Icon(Icons.mic))
            // SpeedDial(
            //     animatedIcon: AnimatedIcons.menu_close,
            //     children: [
            //       SpeedDialChild(
            //           child: const Icon(Icons.mic),
            //           label: 'Force turn on mic',
            //           onTap: () async {
            //             _initSpeech();
            //             setState(() {
            //               forceSpeak = true;
            //             });
            //           }),
            //       SpeedDialChild(
            //         child: const Icon(Icons.mic_off),
            //         label: 'Force turn off mic',
            //         onTap: () async {
            //           await _speechToText.stop();
            //           setState(() {
            //             forceSpeak = false;
            //           });
            //         },
            //       )
            //     ],
            //   )
            null
            : bottomNavBar
        // FloatingActionButton(
        //   onPressed: () async {
        //     await _speechToText.stop();
        //   },
        //   // If not yet listening for speech start, otherwise stop

        //   tooltip: 'Listen',
        //   child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        // )

        //  bottomNavigationBar: bottomNavBar,
        );
  }

  Drawer drawerWidget(BuildContext context) {
    final kTitleTextStyle = const TextStyle(
      fontSize: 15 * 1.7,
      fontWeight: FontWeight.w600,
    );

    final kButtonTextStyle = const TextStyle(
      fontSize: 20 * 1.5,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: 10 * 10,
            width: 10 * 10,
            margin: const EdgeInsets.only(top: 10 * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(widget.currentUserProfilePic!),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10 * 2),
          Text(
            widget.currentUserName!,
            style: kTitleTextStyle,
          ),
          const SizedBox(height: 10 * 0.5),
        ],
      ),
    );
    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(width: 10 * 3),
        profileInfo,
      ],
    );
    String privacyInfo = "";
    if (forceSpeak) {
      privacyInfo = "Mic has been turned on";
    } else {
      privacyInfo = "Mic has been turned off";
    }
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          header,
          ProfileListItem(
            icon: LineAwesomeIcons.user_secret,
            text: 'Privacy --> $privacyInfo',
            hasNavigation: false,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OnBoarding()
                    // HelpAndSupport(
                    //   currentUserName: widget.currentUserName,
                    //   currentUserProfilePic: widget.currentUserProfilePic,
                    //   currentUserUID: widget.currentUserUID,
                    //   isHandsFree: widget.isHandsFree,
                    // ),
                    ),
              );
            },
            child: Container(
              color: Colors.amberAccent,
              width: MediaQuery.of(context).size.width * 0.7,
              child: const ProfileListItem(
                icon: LineAwesomeIcons.question_circle,
                text: 'Help and Support',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LanguagePreferences(
                        currentUserName: widget.currentUserName,
                        currentUserUID: widget.currentUserUID,
                        currentUserProfilePic: widget.currentUserProfilePic)),
              );
            },
            child: Container(
              color: Colors.amberAccent,
              width: MediaQuery.of(context).size.width * 0.7,
              child: const ProfileListItem(
                icon: LineAwesomeIcons.cog,
                text: 'Settings',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              logout();
            },
            child: Container(
              color: Colors.amberAccent,
              width: MediaQuery.of(context).size.width * 0.7,
              child: const ProfileListItem(
                icon: LineAwesomeIcons.alternate_sign_out,
                text: 'Logout',
                hasNavigation: false,
              ),
            ),
          )
        ],
      ),
    );
  }

  StreamBuilder<List<Note>> homeFeedBuilder() {
    return StreamBuilder(
      stream: Stream.fromFuture(tdObject.readAllNotes()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var tweets = snapshot.data as List<Note>;

          return ScrollablePositionedList.builder(
              itemCount: tweets.length,
              itemScrollController: itemController,
              itemBuilder: (context, index) {
                return Tweet(
                  avatar:
                      "https://images.freeimages.com/images/large-previews/7fc/network-switch-1243331.jpg",
                  username: tweets[index].title,
                  textOriginal: tweets[index].description,
                  textTranslated: tweets[index].translated,
                  comments: "comments",
                  retweets: "retweets",
                  favorites: "favorite`s",
                  translate: "Translate",
                );
              });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Widget searchFeedBuilder(var searchTweets) {
    print("Search feed builder");

    return ScrollablePositionedList.builder(
        itemCount: searchTweets.length,
        itemScrollController: itemController,
        itemBuilder: (context, index) {
          return Tweet(
            avatar:
                "https://images.freeimages.com/images/large-previews/7fc/network-switch-1243331.jpg",
            username: searchTweets[index].title,
            textOriginal: searchTweets[index].description,
            textTranslated: searchTweets[index].translated,
            comments: "comments",
            retweets: "retweets",
            favorites: "favorite`s",
            translate: "Translate",
          );
        });
  }

  logout() {
    print("USER HAS CURRENTLY LOGGED OUT");
    if (widget.isLogoutAllowed) {
      firebaseAuth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  displayTranslate() {
    print("THIS IS THE TRANSLATED VERSION");
  }

  setupAlan() {
    AlanVoice.addButton(
        "bb5b48e187d9f0339e6d48eb69d453062e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.callbacks.add((command) => handleCommand(command.data));
  }

  bool isScrollingEnabledHf = true;
  handleCommand(Map<String, dynamic> response) async {
    //flutterTts.stop();
    if (response["command"] == "stop") {
      print("===========STOP COMMAND IS CALLED==========");
      isScrollingEnabledHf = true;
      stopSpeechHandsFree();
    } else if (response["command"] == "play") {
      // await Future.delayed(Duration(seconds: 2), () {
      AlanVoice.deactivate();
      //   });
      print("===========PLAY IS CALLED==========");
      if (isScrollingEnabledHf) {
        setState(() {
          pause = false;
        });
        isScrollingEnabledHf = false;
        _startScrollingTweetsHandsFree(counter: counter);
      }
    } else if (response["command"] == "stop.") {
      print("===========STOP COMMAND IS CALLED==========");
      stopSpeechHandsFree();
    } else if (response["command"] == "play.") {
      print("===========PLAY IS CALLED==========");
      _startScrollingTweetsHandsFree(counter: counter);
      setState(() {
        pause = false;
      });
    } else {
      print("Command was ${response["command"]}");
    }
  }

  scrollToItem(int i) async {
    if (itemController.isAttached) {
      itemController.scrollTo(index: i, duration: const Duration(seconds: 2));
    }
    print("Scrolling");
  }

  void speechTracker() async {
    if (!pause) {
      stopSpeech();
    } else {
      setState(() {
        pause = !pause;
      });
      _startScrollingTweets(counter: counter);
    }
  }

  void stopSpeech() async {
    setState(() {
      pause = !pause;
    });
    await flutterTts.stop();
  }

  void stopSpeechHandsFree() async {
    setState(() {
      pause = true;
    });
    await flutterTts.stop();
  }

  _startScrollingTweets({int counter = 0}) async {
    dynamic tweets;
    if (widget.isSearchFeed) {
      tweets = widget.searchTweets;
    } else {
      tweets = await tdObject.readAllNotes();
    }

    // if (await AlanVoice.isActive()) {
    //   print("=========ALAN VOICE IS TURNED ON=========");
    //   await flutterTts.stop();
    // }
    //reading the notes out loud
    for (int j = counter; j < tweets.length; j++) {
      flutterTts.setPitch(0.7);
      flutterTts.setSpeechRate(0.46);
      await flutterTts.awaitSpeakCompletion(true);
      print("================SCROLOLLING TO ${j}==========");
      await flutterTts
          .speak("${tweets[j].title}Tweeted${tweets[j].description}");
      if (pause == true) {
        print("================J AT PAUSED AT ${j + 1} ========");

        break;
      } else {
        Future.delayed(Duration(milliseconds: 1000), () {
          scrollToItem(j + 1);
        });

        setState(() {
          this.counter = j + 1;
        });
      }
    }
  }

  _startScrollingTweetsHandsFree({int counter = 0}) async {
    dynamic tweets;
    if (widget.isSearchFeed) {
      tweets = widget.searchTweets;
    } else {
      tweets = await tdObject.readAllNotes();
    }

    for (int j = counter; j < tweets.length; j++) {
      //checkVolumeAlan();
      flutterTts.setVolume(0.7);
      flutterTts.setPitch(0.7);
      flutterTts.setSpeechRate(0.5);

      await flutterTts.awaitSpeakCompletion(true);
      print("================SCROLOLLING TO ${j}==========");

      // List<String> split = [];
      // String str = tweets[j].description;
      // final divisionIndex = str.length ~/ 2;

      // for (int i = 0; i < str.length; i++) {
      //   if (i % divisionIndex == 0) {
      //     final tempString = str.substring(i, i + divisionIndex);
      //     print("============TEMP STRING:" + tempString);
      //     split.add(tempString);
      //   }
      // }
      List<String> split = tweets[j].description.split(" ");
      await flutterTts.speak("${tweets[j].title}Tweeted");
      int INCREMENTOR = 3;
      int indexStart = 0;
      int indexEnd = INCREMENTOR;

      String word = "";
      while (true) {
        for (int i = indexStart; i < indexEnd; i++) {
          if (i >= split.length) {
            break;
          }
          word = word + " " + split[i];
        }

        await flutterTts.speak(word);
        word = "";
        print(
            "===========SENTENCE BEING READ==========${word}=====================");
        checkVolumeAlan();
        indexStart += INCREMENTOR;
        indexEnd += INCREMENTOR;
        if (indexStart >= split.length) break;
      }

      if (pause == true) {
        print("================J AT PAUSED AT ${j + 1} ========");

        break;
      } else {
        Future.delayed(Duration(milliseconds: 1000), () {
          scrollToItem(j + 1);
        });

        setState(() {
          this.counter = j + 1;
        });
      }
    }
  }

  void checkVolumeAlan() async {
    if (await AlanVoice.isActive()) {
      print("=========ALAN VOICE IS LOW=========");
      await flutterTts.setVolume(0.01);
    } else if (!(await AlanVoice.isActive())) {
      print("=========ALAN VOICE IS HIGH=========");
      await flutterTts.setVolume(0.7);
    }
  }

  List<String> splitStringByLength(String str, double length) {
    List<String> data = [];

    data.add(str.substring(0, length.round()));
    data.add(str.substring(length.round(), length.round() * 2));
    return data;
  }

  // void _initSpeech() async {
  //   _speechEnabled = await _speechToText.initialize();
  //   setState(() {
  //     _startListening();
  //   });
  // }

  // void _startListening() async {
  //   await _speechToText.listen(onResult: _onSpeechResult);
  //   setState(() {
  //     _speechEnabled = true;
  //   });
  // }

  // void _stopListening() async {
  //   await _speechToText.stop();

  //   setState(() {
  //     Future.delayed(const Duration(milliseconds: 100), () {
  //       _startListening();
  //       print("THE MIC STARTED WORKING AGAIN");
  //     });
  //   });
  // }

  // void _onSpeechResult(SpeechRecognitionResult result) {
  //   setState(() {
  //     _lastWords = result.recognizedWords;
  //     Future.delayed(const Duration(milliseconds: 1), () {
  //       _stopListening();
  //     });
  //   });
  // }

  // void speechLogic() {
  //   if (_speechToText.isListening) {
  //     print('=======$_lastWords=======');
  //     if ('$_lastWords'.toLowerCase().contains("tap")) {
  //       print("WOW THIS IS REALLY WORKING");
  //       speechTracker();
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         setState(() {
  //           _lastWords = "";
  //           _speechEnabled = false;
  //         });
  //       });
  //     }
  //   } else {
  //     if (_speechEnabled) {
  //       print("TAP THE MIC TO START LISTENING");
  //     } else {
  //       print("SPEECH NOT AVAILABLE");
  //     }
  //   }
  //   _lastWords = "";
  // }

  void getTranslateValue() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserUID)
        .get()
        .then((value) {
      //'value' is the instance of 'DocumentSnapshot'
      //'value.data()' contains all the data inside a document in the form of 'dictionary'
      var fields = value.data();
      setState(() {
        finalTranslation = fields!['translation'];
        widget.isHandsFree = fields['hands_free'];
      });
    });
  }

  // Future<Null> refresh() async {
  //   //Holding pull to refresh loader widget for 2 sec.
  //   //You can fetch data from server.
  //   Future.delayed(const Duration(seconds: 2), () {
  //     Feed(
  //         isSearchFeed: widget.isSearchFeed,
  //         searchTweets: widget.searchTweets,
  //         isLogoutAllowed: true,
  //         isHandsFree: widget.isHandsFree,
  //         currentUserUID: widget.currentUserName,
  //         currentUserProfilePic: widget.currentUserProfilePic,
  //         currentUserName: widget.currentUserName);
  //   });

  //   return null;
  // }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 10 * 2.5,
        ),
        const SizedBox(width: 10 * 1.5),
        Text(
          this.text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (this.hasNavigation)
          const Icon(
            Icons.arrow_right_alt_outlined,
            size: 10 * 2.5,
          ),
      ],
    );
  }
}
