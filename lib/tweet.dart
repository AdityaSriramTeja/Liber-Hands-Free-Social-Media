import 'package:flutter/material.dart';

class Tweet extends StatefulWidget {
  final String avatar;
  final String username;
  //final String name;
//  final String timeAgo;
  final String textOriginal;
  final String textTranslated;
  final String comments;
  final String retweets;
  final String favorites;
  final String translate;
  const Tweet(
      {Key? key,
      required this.avatar,
      required this.username,
      //required this.name,
      //required this.timeAgo,
      required this.textOriginal,
      required this.comments,
      required this.retweets,
      required this.favorites,
      required this.translate,
      required this.textTranslated})
      : super(key: key);

  @override
  State<Tweet> createState() => _TweetState();
}

class _TweetState extends State<Tweet> {
  bool translation = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetAvatar(),
          tweetBody(),
        ],
      ),
    );
  }

  Widget tweetAvatar() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        backgroundImage: NetworkImage(widget.avatar),
      ),
    );
  }

  Widget tweetBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetHeader(),
          tweetText(),
          tweetButtons(),
        ],
      ),
    );
  }

  Widget tweetHeader() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5.0),
          child: Text(
            widget.username,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Text(
        //   '@${widget.name} · ${widget.timeAgo}',
        //   style: const TextStyle(
        //     color: Colors.grey,
        //   ),
        // ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.arrow_downward,
            size: 14.0,
            color: Colors.grey,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget tweetText() {
    return Text(
      translation ? widget.textTranslated : widget.textOriginal,
    );
  }

  Widget tweetButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // tweetIconButton(Icons.comment, comments),
          // tweetIconButton(Icons.send, retweets),
          //  tweetIconButton(Icons.favorite, favorites),
          tweetIconButton(Icons.translate, widget.translate),
        ],
      ),
    );
  }

  Widget tweetIconButton(IconData icon, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          translation = !translation;
        });
      },
      child: Row(
        children: [
          IconButton(
            icon: Icon(icon),
            iconSize: 16.0,
            color: Colors.black45,
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.all(6.0),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
