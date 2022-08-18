import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:twitter_hackathon/model/tweetModelDb.dart';

import 'model/note.dart';
part 'app_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'tweetStorage.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [TweetDb])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<TweetDbData>> getTweetsDrift() async {
    return await select(tweetDb).get();
  }

  Future<TweetDbData> getTweetDrift(int id) async {
    return await (select(tweetDb)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<bool> updateTweetDrift(TweetDbCompanion entity) async {
    return await update(tweetDb).replace(entity);
  }

  Future<int> insertTweetDrift(TweetDbCompanion entity) async {
    return await into(tweetDb).insert(entity);
  }
}
