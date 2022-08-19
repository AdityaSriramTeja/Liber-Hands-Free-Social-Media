// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:twitter_hackathon/feed.dart';

// import 'package:twitter_hackathon/tweetsDemo.dart';
// import 'package:twitter_login/twitter_login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       // options: DefaultFirebaseOptions.currentPlatform,
//       );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Twitter',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const LoginScreen(),
//     );
//   }
// }

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           elevation: 1,
//           backgroundColor: Colors.white,
//           leading: Container(
//             margin: const EdgeInsets.all(10.0),
//           ),
//           title: const Text(
//             'Login Screen',
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: Center(
//             child: ElevatedButton(
//           onPressed: () => login(),
//           child: const Text("Login with twitter"),
//         )
//             // listOfTweets(),
//             // floatingActionButton: FloatingActionButton(
//             //   child: const Icon(Icons.person_remove),
//             //   onPressed: () {},
//             // ),
//             // bottomNavigationBar: BottomAppBar(
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             //     children: [
//             //       buildBottomIconButton(Icons.home, Colors.blue),
//             //       buildBottomIconButton(Icons.search, Colors.black45),
//             //       buildBottomIconButton(Icons.notifications, Colors.black45),
//             //       buildBottomIconButton(Icons.mail_outline, Colors.black45),
//             //     ],
//             //   ),
//             // ),
//             ));
//   }

//   Widget buildBottomIconButton(IconData icon, Color color) {
//     return IconButton(
//       icon: Icon(
//         icon,
//         color: color,
//       ),
//       onPressed: () {},
//     );
//   }

//   Widget listOfTweets() {
//     return Container(
//       color: Colors.white,
//       child: ListView.separated(
//         itemBuilder: (BuildContext context, int index) {
//           return tweets[index];
//         },
//         separatorBuilder: (BuildContext context, int index) => const Divider(
//           height: 0,
//         ),
//         itemCount: tweets.length,
//       ),
//     );
//   }

//   login() async {
//     final twitterLogin = TwitterLogin(
//       /// Consumer API keys
//       apiKey: 'h9reOghMaBCMqgmweFC0bEhTn',

//       /// Consumer API Secret keys
//       apiSecretKey: 'f1R5NwzQc8IZsJekSK4gAbbEQPhta7KiNulhedRgMNOMIf469q',

//       /// Registered Callback URLs in TwitterApp
//       /// Android is a deeplink
//       /// iOS is a URLScheme
//       redirectURI: 'twitterhackathon://',
//     );

//     /// Forces the user to enter their credentials
//     /// to ensure the correct users account is authorized.
//     /// If you want to implement Twitter account switching, set [force_login] to true
//     /// login(forceLogin: true);
//     final authResult = await twitterLogin.loginV2();
//     switch (authResult.status) {
//       case TwitterLoginStatus.loggedIn:
//         // success
//         print('====== Login success ======');
//         print(authResult.authToken);
//         print(authResult.authTokenSecret);
//         final AuthCredential twitterAuthCredential =
//             TwitterAuthProvider.credential(
//                 accessToken: authResult.authToken!,
//                 secret: authResult.authTokenSecret!);

//         await firebaseAuth.signInWithCredential(twitterAuthCredential);
//         navigateToFeed();

//         break;
//       case TwitterLoginStatus.cancelledByUser:
//         // cancel
//         print('====== Login cancel ======');
//         break;
//       case TwitterLoginStatus.error:
//       case null:
//         // error
//         print('====== Login error ======');
//         break;
//     }
//   }

//   navigateToFeed() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const Feed()),
//     );
//   }

//   // logout() {
//   //   firebaseAuth.signOut();
//   // }
// }
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twitter_hackathon/getTweets.dart';
import 'package:twitter_hackathon/languagePreferences.dart';
import 'package:twitter_hackathon/splashLanguage.dart';
import 'package:twitter_hackathon/testWeb.dart';
import 'package:twitter_hackathon/tweet_database.dart';

import 'package:twitter_login/twitter_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  //Initialize the database
  var tdObject = TweetsDatabase.instance;
  await tdObject.initDB('notes.db');
  // await tdObject.deleteAll();
  GetTweets tweetController = GetTweets();
  //Get new tweets from the API
  //var tweets = await tweetController.getTweets("twitterdev");

  runApp(MyApp(
      //tweets: tweets,
      ));
}

class MyApp extends StatelessWidget {
  var tweets;
  MyApp({super.key, this.tweets});

  dynamic get tweetsApi {
    return tweets;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  static List<dynamic> searchQuery = [];
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return const SplashLanguage();
        } else {
          return const LoginScreen();
        }
      }),
    ));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<Color> gradient1 = [Color(0xFF043E49), Color(0xFF1E7879)];
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 8),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: 30),
              Container(
                height: 50.0,
                margin: EdgeInsets.all(10),
                child: RaisedButton(
                  onPressed: () {
                    login();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Developed by Aditya Sriramteja Chilukuri",
                            style: GoogleFonts.bebasNeue(
                              textStyle:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "and Shreyas Peddi",
                            style: GoogleFonts.bebasNeue(
                              textStyle:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildBottomIconButton(IconData icon, Color color) {
  //   return IconButton(
  //     icon: Icon(
  //       icon,
  //       color: color,
  //     ),
  //     onPressed: () {},
  //   );
  // }

  // Widget listOfTweets() {
  //   return Container(
  //     color: Colors.white,
  //     child: ListView.separated(
  //       itemBuilder: (BuildContext context, int index) {
  //         return tweets[index];
  //       },
  //       separatorBuilder: (BuildContext context, int index) => const Divider(
  //         height: 0,
  //       ),
  //       itemCount: tweets.length,
  //     ),
  //   );
  // }

  login() async {
    final twitterLogin = TwitterLogin(
      /// Consumer API keys
      apiKey: 'h9reOghMaBCMqgmweFC0bEhTn',

      /// Consumer API Secret keys
      apiSecretKey: 'f1R5NwzQc8IZsJekSK4gAbbEQPhta7KiNulhedRgMNOMIf469q',

      /// Registered Callback URLs in TwitterApp
      /// Android is a deeplink
      /// iOS is a URLScheme
      redirectURI: 'twitterhackathon://',
    );

    /// Forces the user to enter their credentials
    /// to ensure the correct users account is authorized.
    /// If you want to implement Twitter account switching, set [force_login] to true
    /// login(forceLogin: true);
    final authResult = await twitterLogin.loginV2();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        // success
        print('====== Login success ======');
        print(authResult.authToken);
        print(authResult.authTokenSecret);
        final AuthCredential twitterAuthCredential =
            TwitterAuthProvider.credential(
                accessToken: authResult.authToken!,
                secret: authResult.authTokenSecret!);
        await TweetsDatabase.instance.initDB('notes.db');
        UserCredential userCredential =
            await firebaseAuth.signInWithCredential(twitterAuthCredential);
        User? user = userCredential.user;
        User? currentUser = FirebaseAuth.instance.currentUser;
        print("CURRENT USERS EMAIL IS ${currentUser?.email}");
        print("CURRENT USERS UID IS ${currentUser?.uid}");

        if (userCredential.additionalUserInfo!.isNewUser) {
          // print("THIS IS A NEW USER");
          // return Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const SplashLanguage()),
          // );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .set({
            'uid': currentUser.uid,
            'profile_pic': currentUser.photoURL,
            'name': currentUser.displayName,
            'new_user': true,
          });
        } else {
          // await FirebaseFirestore.instance
          //     .collection('users')
          //     .doc(currentUser!.uid)
          //     .set({
          //   'uids': currentUser.uid,
          //   'profile_pic': currentUser.photoURL,
          //   'name': currentUser.displayName,
          //   'new_user': false,
          // });
          dynamic languageCode;
          GetTweets tweetController = GetTweets();
          var tdObject = TweetsDatabase.instance;

          //Delete all previous database data
          await tdObject.deleteAll();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .get()
              .then((value) {
            //'value' is the instance of 'DocumentSnapshot'
            //'value.data()' contains all the data inside a document in the form of 'dictionary'
            var fields = value.data();

            languageCode = fields!['translation'];
            MainPage.searchQuery = fields['search_query'];
          });

          LanguagePreferences.defaultLanguage = languageCode;
          List<dynamic> queries = MainPage.searchQuery;
          print(
              "===============================QUERIES FROM MAIN: ${queries}}==========================");
          Random random = new Random();
          int randomNumber = random.nextInt(4);
          //Get new tweets from the API
          var tweets = await tweetController.getTweets(queries[randomNumber]);
          //Store tweets in database
          await tweetController.storeTweetsinDB(tweets, languageCode);
        }
        break;
      //   navigateToFeed();
      case TwitterLoginStatus.cancelledByUser:
        // cancel

        print('====== Login cancel ======');
        break;
      case TwitterLoginStatus.error:
        print("====error====");
        break;
      case null:
        // error
        print('====== Login error ======');
        break;
    }
  }

  // navigateToFeed() {
  //   Navigator.pushNamedAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => const Feed()),
  //   );
  // }
}
