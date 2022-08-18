import 'package:drift/drift.dart';

class TweetDb extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().named("title")();
  TextColumn get tweetData => text().named("tweet_data")();
  TextColumn get translatedData => text().named("translated_data")();
}
