// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class TweetDbData extends DataClass implements Insertable<TweetDbData> {
  final int id;
  final String title;
  final String tweetData;
  final String translatedData;
  const TweetDbData(
      {required this.id,
      required this.title,
      required this.tweetData,
      required this.translatedData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['tweet_data'] = Variable<String>(tweetData);
    map['translated_data'] = Variable<String>(translatedData);
    return map;
  }

  TweetDbCompanion toCompanion(bool nullToAbsent) {
    return TweetDbCompanion(
      id: Value(id),
      title: Value(title),
      tweetData: Value(tweetData),
      translatedData: Value(translatedData),
    );
  }

  factory TweetDbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TweetDbData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      tweetData: serializer.fromJson<String>(json['tweetData']),
      translatedData: serializer.fromJson<String>(json['translatedData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'tweetData': serializer.toJson<String>(tweetData),
      'translatedData': serializer.toJson<String>(translatedData),
    };
  }

  TweetDbData copyWith(
          {int? id,
          String? title,
          String? tweetData,
          String? translatedData}) =>
      TweetDbData(
        id: id ?? this.id,
        title: title ?? this.title,
        tweetData: tweetData ?? this.tweetData,
        translatedData: translatedData ?? this.translatedData,
      );
  @override
  String toString() {
    return (StringBuffer('TweetDbData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('tweetData: $tweetData, ')
          ..write('translatedData: $translatedData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, tweetData, translatedData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TweetDbData &&
          other.id == this.id &&
          other.title == this.title &&
          other.tweetData == this.tweetData &&
          other.translatedData == this.translatedData);
}

class TweetDbCompanion extends UpdateCompanion<TweetDbData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> tweetData;
  final Value<String> translatedData;
  const TweetDbCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.tweetData = const Value.absent(),
    this.translatedData = const Value.absent(),
  });
  TweetDbCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String tweetData,
    required String translatedData,
  })  : title = Value(title),
        tweetData = Value(tweetData),
        translatedData = Value(translatedData);
  static Insertable<TweetDbData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? tweetData,
    Expression<String>? translatedData,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (tweetData != null) 'tweet_data': tweetData,
      if (translatedData != null) 'translated_data': translatedData,
    });
  }

  TweetDbCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? tweetData,
      Value<String>? translatedData}) {
    return TweetDbCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      tweetData: tweetData ?? this.tweetData,
      translatedData: translatedData ?? this.translatedData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (tweetData.present) {
      map['tweet_data'] = Variable<String>(tweetData.value);
    }
    if (translatedData.present) {
      map['translated_data'] = Variable<String>(translatedData.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TweetDbCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('tweetData: $tweetData, ')
          ..write('translatedData: $translatedData')
          ..write(')'))
        .toString();
  }
}

class $TweetDbTable extends TweetDb with TableInfo<$TweetDbTable, TweetDbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TweetDbTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _tweetDataMeta = const VerificationMeta('tweetData');
  @override
  late final GeneratedColumn<String> tweetData = GeneratedColumn<String>(
      'tweet_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _translatedDataMeta =
      const VerificationMeta('translatedData');
  @override
  late final GeneratedColumn<String> translatedData = GeneratedColumn<String>(
      'translated_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, tweetData, translatedData];
  @override
  String get aliasedName => _alias ?? 'tweet_db';
  @override
  String get actualTableName => 'tweet_db';
  @override
  VerificationContext validateIntegrity(Insertable<TweetDbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('tweet_data')) {
      context.handle(_tweetDataMeta,
          tweetData.isAcceptableOrUnknown(data['tweet_data']!, _tweetDataMeta));
    } else if (isInserting) {
      context.missing(_tweetDataMeta);
    }
    if (data.containsKey('translated_data')) {
      context.handle(
          _translatedDataMeta,
          translatedData.isAcceptableOrUnknown(
              data['translated_data']!, _translatedDataMeta));
    } else if (isInserting) {
      context.missing(_translatedDataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TweetDbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TweetDbData(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      tweetData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}tweet_data'])!,
      translatedData: attachedDatabase.options.types.read(
          DriftSqlType.string, data['${effectivePrefix}translated_data'])!,
    );
  }

  @override
  $TweetDbTable createAlias(String alias) {
    return $TweetDbTable(attachedDatabase, alias);
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  late final $TweetDbTable tweetDb = $TweetDbTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tweetDb];
}
