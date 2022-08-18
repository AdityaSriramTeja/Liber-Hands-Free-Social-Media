import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:twitter_hackathon/feed.dart';
import 'package:twitter_hackathon/languagePreferences.dart';

class HelpAndSupport extends StatefulWidget {
  final String? currentUserUID;
  final String? currentUserProfilePic;
  final String? currentUserName;
  final bool isHandsFree;

  const HelpAndSupport({
    Key? key,
    this.currentUserUID,
    this.currentUserProfilePic,
    this.currentUserName,
    required this.isHandsFree,
  }) : super(key: key);

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help and Support"),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Image.asset('assets/images/support1.jpg'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Hands Free',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(2.0),
          child: Center(
            child: Text(
              "'Tap' is the command word",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
                'Lorem ipsum dolor sit amet,consectetur adipiscing elit. Sed efficitur imperdiet elit, eu malesuada dui condimentum vel. Suspendisse ultrices libero quis metus lobortis, sed viverra urna pretium. Duis ac ligula faucibus, aliquam lacus eget, dignissim metus. Nunc eget mi velit. In nec nibh a ante feugiat scelerisque. '),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 230,
                top: 20,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => Feed(
                  //           currentUserName: widget.currentUserName,
                  //           currentUserProfilePic: widget.currentUserProfilePic,
                  //           currentUserUID: widget.currentUserUID,
                  //           isSearchFeed: false,
                  //           searchTweets: null,
                  //           isLogoutAllowed: true,
                  //           isHandsFree:
                  //               LanguagePreferences.isHandsFreeSetting)),
                  // );
                },
                child: const Text("skip",
                    style: TextStyle(decoration: TextDecoration.underline)),
              ),
            ),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HelpAndSupport2(
                      currentUserName: widget.currentUserName,
                      currentUserProfilePic: widget.currentUserProfilePic,
                      currentUserUID: widget.currentUserUID,
                      isHandsFree: widget.isHandsFree,
                    )),
          );
        },
      ),
    );
  }
}

class HelpAndSupport2 extends StatefulWidget {
  final String? currentUserUID;
  final String? currentUserProfilePic;
  final String? currentUserName;
  final bool isHandsFree;

  const HelpAndSupport2(
      {Key? key,
      this.currentUserUID,
      this.currentUserProfilePic,
      this.currentUserName,
      required this.isHandsFree})
      : super(key: key);

  @override
  State<HelpAndSupport2> createState() => _HelpAndSupport2State();
}

class _HelpAndSupport2State extends State<HelpAndSupport2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help and Support"),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Image.asset('assets/images/support2.gif'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text('Hands On'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed efficitur imperdiet elit, eu malesuada dui condimentum vel. Suspendisse ultrices libero quis metus lobortis, sed viverra urna pretium. Duis ac ligula faucibus, aliquam lacus eget, dignissim metus. Nunc eget mi velit. In nec nibh a ante feugiat scelerisque. '),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HelpAndSupport3(
                      currentUserName: widget.currentUserName,
                      currentUserProfilePic: widget.currentUserProfilePic,
                      currentUserUID: widget.currentUserUID,
                      isHandsFree: widget.isHandsFree,
                    )),
          );
        },
      ),
    );
  }
}

class HelpAndSupport3 extends StatefulWidget {
  final String? currentUserUID;
  final String? currentUserProfilePic;
  final String? currentUserName;
  final bool isHandsFree;

  const HelpAndSupport3(
      {Key? key,
      this.currentUserUID,
      this.currentUserProfilePic,
      this.currentUserName,
      required this.isHandsFree})
      : super(key: key);

  @override
  State<HelpAndSupport3> createState() => _HelpAndSupport3State();
}

class _HelpAndSupport3State extends State<HelpAndSupport3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help and Support"),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Image.asset('assets/images/support3.gif'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text('Cloud'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
                'Cloud Feature provides better accessibility. Settings enabled on your account will be in sync with any device you log in with. For example, your preferred translation language will be saved through all your devices!'),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => Feed(
          // currentUserName: widget.currentUserName,
          // currentUserProfilePic: widget.currentUserProfilePic,
          // currentUserUID: widget.currentUserUID,
          // isSearchFeed: false,
          // searchTweets: null,
          // isLogoutAllowed: true,
          // isHandsFree: widget.isHandsFree)),
          // );

          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }
}
