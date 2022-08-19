import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

import 'feed.dart';

class OnBoarding extends StatefulWidget {
  final isSetup;
  final isHandFree;
  final currentUsername;
  final currentUserUID;
  final currentUserProfilePic;
  final pageValue;
  final queries;
  const OnBoarding(
      {Key? key,
      required this.isSetup,
      required this.isHandFree,
      required this.currentUsername,
      required this.currentUserUID,
      required this.currentUserProfilePic,
      required this.queries,
      this.pageValue})
      : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late Material materialButton;
  late int index;

  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image.asset(
                  'assets/images/support1.jpg',
                  //color: pageImageColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'HANDS FREE',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Say 'Hey Alan' to activate voice assistant. Clicking on the hands-free button will also activate the voice assistant",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.7,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "After enabling voice assistant:",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.7,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 55.0,
                  right: 45.0,
                  top: 5,
                  bottom: 5,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "--> Say 'Play' to start listening to the tweets ",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.7,
                        height: 1.5,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 55.0,
                  right: 45.0,
                  top: 5,
                  bottom: 5,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "--> Say 'Stop' to stop listening to the tweets ",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.7,
                        height: 1.5,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 55.0,
                  right: 45.0,
                  top: 5,
                  bottom: 5,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "--> Say 'Search' to search for any twitter queries",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.7,
                        height: 1.5,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 55.0,
                  right: 45.0,
                  top: 5,
                  bottom: 5,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "--> Say 'Help' to view the resources guide",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.7,
                        height: 1.5,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 55.0,
                  right: 45.0,
                  top: 5,
                  bottom: 5,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "--> Say 'Logout' to logout from the app",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.7,
                        height: 1.5,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 45.0,
                  right: 45,
                  bottom: 90,
                  top: 90,
                ),
                child: Image.asset(
                  'assets/images/support2.gif',
                  //color: pageImageColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'HANDS ON',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  right: 45.0,
                  left: 45,
                  top: 45.0,
                  bottom: 150,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Seamlessly switch to hands-on mode to use the app without voice commands',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 45.0,
                  left: 45.0,
                  top: 50,
                  bottom: 30,
                ),
                child: Image.asset(
                  'assets/images/privacy.jpg',
                  //color: pageImageColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PRIVACY',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text(
                        "You can always view if the mic is turned on/off on the app's drawer",
                        style: pageInfoStyle,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 45, top: 10),
                child: Column(
                  children: [
                    Text(
                      "Black App Bar  = Hands-Free",
                      style: pageInfoStyle,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Yellow App Bar = Hands-On",
                      style: pageInfoStyle,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image.asset(
                  'assets/images/support3.gif',
                  //color: pageImageColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'CLOUD',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                    right: 45.0, left: 45, top: 10.0, bottom: 240),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your settings and preferences will be in sync across all the devices you use",
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
    //AlanVoice.removeButton();
    //setupAlan();
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = 3;
            setIndex(3);
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Material get _showFeedButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: defaultProceedButtonColor,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {},
        child: Padding(
          padding: defaultProceedButtonPadding,
          child: GestureDetector(
            onTap: () {
              if (widget.isSetup) {
                print(
                    "=======================PUSH REPLACINg====================");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Feed(
                      isSearchFeed: false,
                      searchTweets: null,
                      isLogoutAllowed: true,
                      isHandsFree: widget.isHandFree,
                      currentUserName: widget.currentUsername,
                      currentUserUID: widget.currentUserUID,
                      currentUserProfilePic: widget.currentUserProfilePic,
                      queries: widget.queries,
                    ),
                  ),
                );
              } else {
                print("=======================POPPING OFF====================");
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
            child: Text(
              'Show Feed',
              style: defaultProceedButtonTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  setupAlan() {
    AlanVoice.addButton(
        "bb5b48e187d9f0339e6d48eb69d453062e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    AlanVoice.callbacks.add((command) => handleCommand(command.data));
  }

  handleCommand(Map<String, dynamic> response) async {
    //flutterTts.stop();
    if (response["command"] == "go") {
      nextPage(1);
    } else if (response["command"] == "help two") {
    } else {
      print("Command was ${response["command"]}");
    }
  }

  nextPage(int pageNum, {void Function(int)? setIndex}) {
    if (setIndex != null) {
      index = pageNum;
      setIndex(pageNum);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Onboarding(
          pages: onboardingPagesList,
          onPageChange: (int pageIndex) {
            index = pageIndex;
          },
          startPageIndex: 0,
          footerBuilder: (context, dragDistance, pagesLength, setIndex) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: background,
                border: Border.all(
                  width: 0.0,
                  color: background,
                ),
              ),
              child: ColoredBox(
                color: background,
                child: Padding(
                  padding: const EdgeInsets.all(45.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIndicator(
                        netDragPercent: dragDistance,
                        pagesLength: pagesLength,
                        indicator: Indicator(
                          indicatorDesign: IndicatorDesign.line(
                            lineDesign: LineDesign(
                              lineType: DesignType.line_uniform,
                            ),
                          ),
                        ),
                      ),
                      index == pagesLength - 1
                          ? _showFeedButton
                          : _skipButton(setIndex: setIndex)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
