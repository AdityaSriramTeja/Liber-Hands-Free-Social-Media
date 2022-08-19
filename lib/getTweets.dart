import 'package:faker/faker.dart';
import 'package:translator/translator.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;
import 'package:twitter_hackathon/tweet_database.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

import 'model/note.dart';

class GetTweets {
  var tdObject = TweetsDatabase.instance;
  late List<Note> tweetsList;
  final twitter = v2.TwitterApi(
    bearerToken:
        'AAAAAAAAAAAAAAAAAAAAAGIKeQEAAAAAky1uYF9dmm%2F0NcyliUMSrMxPLkw%3DuscOS7DjPvMKCqnxYBAMn8dA7rU7sMD3UVEO7JN3tUSOpcpZGm',
    oauthTokens: v2.OAuthTokens(
      consumerKey: 'h9reOghMaBCMqgmweFC0bEhTn',
      consumerSecret: 'f1R5NwzQc8IZsJekSK4gAbbEQPhta7KiNulhedRgMNOMIf469q',
      accessToken: '1541909837352763392-g8NvGiRKShk5cIZrxlxnrDH56TYZae',
      accessTokenSecret: 'sFjLxWdFFyvWewPq1BWkZYFV6WKxhUHZgK5rtjIQthcVW',
    ),
  );
  GetTweets();

  TweetsDatabase get tdInstance {
    return tdObject;
  }

  List<Note> get tweets {
    return tweetsList;
  }

  //Calls the twitter using bearer token. Tweets are stored based on a query
  Future<TwitterResponse<List<TweetData>, TweetMeta>> getTweets(
      String search) async {
    print("=================SEARCH QUERY IS $search=============");
    var tweets;
    try {
      tweets = await twitter.tweetsService.searchRecent(
          query: '${search}',
          maxResults: 10,
          expansions: [v2.TweetExpansion.authorId]);
      //tweets.data[0].authorId;
    } on v2.TwitterException catch (e) {
      print(e);
    }

    return tweets;
  }

  //Stores tweet object data from api into local database
  storeTweetsinDB(var tweets, String lang) async {
    for (var i = 0; i < tweets.data.length; i++) {
      String twitter_username = faker.person.firstName();

      // await twitter.usersService
      //     .lookupById(userId: tweets.data[i].authorId)
      //     .then((value) {
      //   twitter_username = value.data.username;
      // });
      print("TWITTER USERNAME:" + twitter_username);

      String translation = tweets.data[i].text;

      //Translate data based on the language specified
      translation.translate(to: lang).then((value) async {
        await tdObject.create(Note(
            isImportant: true,
            number: i,
            title: twitter_username,
            description: tweets.data[i].text,
            translated: value.text));
      });

      print("Tweets successfully fetched and stored in database");
    }
  }
}
