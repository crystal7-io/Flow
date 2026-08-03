// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCommentCollection on Isar {
  IsarCollection<Comment> get comments => this.collection();
}

const CommentSchema = CollectionSchema(
  name: r'Comment',
  id: -5579229333153709021,
  properties: {
    r'commentId': PropertySchema(
      id: 0,
      name: r'commentId',
      type: IsarType.string,
    ),
    r'dateTime': PropertySchema(
      id: 1,
      name: r'dateTime',
      type: IsarType.string,
    ),
    r'isLiked': PropertySchema(
      id: 2,
      name: r'isLiked',
      type: IsarType.bool,
    ),
    r'likes': PropertySchema(
      id: 3,
      name: r'likes',
      type: IsarType.long,
    ),
    r'parsedDateTime': PropertySchema(
      id: 4,
      name: r'parsedDateTime',
      type: IsarType.dateTime,
    ),
    r'person': PropertySchema(
      id: 5,
      name: r'person',
      type: IsarType.object,
      target: r'Person',
    ),
    r'postId': PropertySchema(
      id: 6,
      name: r'postId',
      type: IsarType.string,
    ),
    r'replyToCommentId': PropertySchema(
      id: 7,
      name: r'replyToCommentId',
      type: IsarType.string,
    ),
    r'text': PropertySchema(
      id: 8,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _commentEstimateSize,
  serialize: _commentSerialize,
  deserialize: _commentDeserialize,
  deserializeProp: _commentDeserializeProp,
  idName: r'id',
  indexes: {
    r'commentId': IndexSchema(
      id: 3609824276468662262,
      name: r'commentId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'commentId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'postId_parsedDateTime': IndexSchema(
      id: -2842679641178183634,
      name: r'postId_parsedDateTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'postId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'parsedDateTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'parsedDateTime': IndexSchema(
      id: 5548828042538312592,
      name: r'parsedDateTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'parsedDateTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'Person': PersonSchema},
  getId: _commentGetId,
  getLinks: _commentGetLinks,
  attach: _commentAttach,
  version: '3.1.0+1',
);

int _commentEstimateSize(
  Comment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.commentId.length * 3;
  bytesCount += 3 + object.dateTime.length * 3;
  bytesCount += 3 +
      PersonSchema.estimateSize(object.person, allOffsets[Person]!, allOffsets);
  bytesCount += 3 + object.postId.length * 3;
  {
    final value = object.replyToCommentId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _commentSerialize(
  Comment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.commentId);
  writer.writeString(offsets[1], object.dateTime);
  writer.writeBool(offsets[2], object.isLiked);
  writer.writeLong(offsets[3], object.likes);
  writer.writeDateTime(offsets[4], object.parsedDateTime);
  writer.writeObject<Person>(
    offsets[5],
    allOffsets,
    PersonSchema.serialize,
    object.person,
  );
  writer.writeString(offsets[6], object.postId);
  writer.writeString(offsets[7], object.replyToCommentId);
  writer.writeString(offsets[8], object.text);
}

Comment _commentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Comment(
    commentId: reader.readString(offsets[0]),
    dateTime: reader.readString(offsets[1]),
    isLiked: reader.readBoolOrNull(offsets[2]) ?? false,
    likes: reader.readLongOrNull(offsets[3]) ?? 0,
    person: reader.readObjectOrNull<Person>(
          offsets[5],
          PersonSchema.deserialize,
          allOffsets,
        ) ??
        Person(),
    postId: reader.readString(offsets[6]),
    replyToCommentId: reader.readStringOrNull(offsets[7]),
    text: reader.readString(offsets[8]),
  );
  object.id = id;
  object.parsedDateTime = reader.readDateTime(offsets[4]);
  return object;
}

P _commentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<Person>(
            offset,
            PersonSchema.deserialize,
            allOffsets,
          ) ??
          Person()) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _commentGetId(Comment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _commentGetLinks(Comment object) {
  return [];
}

void _commentAttach(IsarCollection<dynamic> col, Id id, Comment object) {
  object.id = id;
}

extension CommentByIndex on IsarCollection<Comment> {
  Future<Comment?> getByCommentId(String commentId) {
    return getByIndex(r'commentId', [commentId]);
  }

  Comment? getByCommentIdSync(String commentId) {
    return getByIndexSync(r'commentId', [commentId]);
  }

  Future<bool> deleteByCommentId(String commentId) {
    return deleteByIndex(r'commentId', [commentId]);
  }

  bool deleteByCommentIdSync(String commentId) {
    return deleteByIndexSync(r'commentId', [commentId]);
  }

  Future<List<Comment?>> getAllByCommentId(List<String> commentIdValues) {
    final values = commentIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'commentId', values);
  }

  List<Comment?> getAllByCommentIdSync(List<String> commentIdValues) {
    final values = commentIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'commentId', values);
  }

  Future<int> deleteAllByCommentId(List<String> commentIdValues) {
    final values = commentIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'commentId', values);
  }

  int deleteAllByCommentIdSync(List<String> commentIdValues) {
    final values = commentIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'commentId', values);
  }

  Future<Id> putByCommentId(Comment object) {
    return putByIndex(r'commentId', object);
  }

  Id putByCommentIdSync(Comment object, {bool saveLinks = true}) {
    return putByIndexSync(r'commentId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCommentId(List<Comment> objects) {
    return putAllByIndex(r'commentId', objects);
  }

  List<Id> putAllByCommentIdSync(List<Comment> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'commentId', objects, saveLinks: saveLinks);
  }
}

extension CommentQueryWhereSort on QueryBuilder<Comment, Comment, QWhere> {
  QueryBuilder<Comment, Comment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhere> anyParsedDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'parsedDateTime'),
      );
    });
  }
}

extension CommentQueryWhere on QueryBuilder<Comment, Comment, QWhereClause> {
  QueryBuilder<Comment, Comment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> commentIdEqualTo(
      String commentId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'commentId',
        value: [commentId],
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> commentIdNotEqualTo(
      String commentId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commentId',
              lower: [],
              upper: [commentId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commentId',
              lower: [commentId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commentId',
              lower: [commentId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commentId',
              lower: [],
              upper: [commentId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause>
      postIdEqualToAnyParsedDateTime(String postId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'postId_parsedDateTime',
        value: [postId],
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause>
      postIdNotEqualToAnyParsedDateTime(String postId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId_parsedDateTime',
              lower: [],
              upper: [postId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId_parsedDateTime',
              lower: [postId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId_parsedDateTime',
              lower: [postId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId_parsedDateTime',
              lower: [],
              upper: [postId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> postIdParsedDateTimeEqualTo(
      String postId, DateTime parsedDateTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'postId_parsedDateTime',
        value: [postId, parsedDateTime],
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause>
      postIdEqualToParsedDateTimeNotEqualTo(
          String postId, DateTime parsedDateTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId_parsedDateTime',
              lower: [postId],
              upper: [postId, parsedDateTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId_parsedDateTime',
              lower: [postId, parsedDateTime],
              includeLower: false,
              upper: [postId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId_parsedDateTime',
              lower: [postId, parsedDateTime],
              includeLower: false,
              upper: [postId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId_parsedDateTime',
              lower: [postId],
              upper: [postId, parsedDateTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause>
      postIdEqualToParsedDateTimeGreaterThan(
    String postId,
    DateTime parsedDateTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'postId_parsedDateTime',
        lower: [postId, parsedDateTime],
        includeLower: include,
        upper: [postId],
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause>
      postIdEqualToParsedDateTimeLessThan(
    String postId,
    DateTime parsedDateTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'postId_parsedDateTime',
        lower: [postId],
        upper: [postId, parsedDateTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause>
      postIdEqualToParsedDateTimeBetween(
    String postId,
    DateTime lowerParsedDateTime,
    DateTime upperParsedDateTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'postId_parsedDateTime',
        lower: [postId, lowerParsedDateTime],
        includeLower: includeLower,
        upper: [postId, upperParsedDateTime],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> parsedDateTimeEqualTo(
      DateTime parsedDateTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parsedDateTime',
        value: [parsedDateTime],
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> parsedDateTimeNotEqualTo(
      DateTime parsedDateTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parsedDateTime',
              lower: [],
              upper: [parsedDateTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parsedDateTime',
              lower: [parsedDateTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parsedDateTime',
              lower: [parsedDateTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parsedDateTime',
              lower: [],
              upper: [parsedDateTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> parsedDateTimeGreaterThan(
    DateTime parsedDateTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parsedDateTime',
        lower: [parsedDateTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> parsedDateTimeLessThan(
    DateTime parsedDateTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parsedDateTime',
        lower: [],
        upper: [parsedDateTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterWhereClause> parsedDateTimeBetween(
    DateTime lowerParsedDateTime,
    DateTime upperParsedDateTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parsedDateTime',
        lower: [lowerParsedDateTime],
        includeLower: includeLower,
        upper: [upperParsedDateTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CommentQueryFilter
    on QueryBuilder<Comment, Comment, QFilterCondition> {
  QueryBuilder<Comment, Comment, QAfterFilterCondition> commentIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> commentIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> commentIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> commentIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> commentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> commentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> commentIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> commentIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> commentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentId',
        value: '',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> commentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commentId',
        value: '',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> dateTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> dateTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> dateTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> dateTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> dateTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> dateTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> dateTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> dateTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> dateTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> dateTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateTime',
        value: '',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> isLikedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isLiked',
        value: value,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> likesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'likes',
        value: value,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> likesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'likes',
        value: value,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> likesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'likes',
        value: value,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> likesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'likes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> parsedDateTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parsedDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition>
      parsedDateTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parsedDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> parsedDateTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parsedDateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> parsedDateTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parsedDateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> postIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> postIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> postIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> postIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'postId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> postIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> postIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> postIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> postIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'postId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> postIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postId',
        value: '',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> postIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'postId',
        value: '',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition>
      replyToCommentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'replyToCommentId',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition>
      replyToCommentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'replyToCommentId',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> replyToCommentIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyToCommentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition>
      replyToCommentIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'replyToCommentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition>
      replyToCommentIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'replyToCommentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> replyToCommentIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'replyToCommentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition>
      replyToCommentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'replyToCommentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition>
      replyToCommentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'replyToCommentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition>
      replyToCommentIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'replyToCommentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> replyToCommentIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'replyToCommentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition>
      replyToCommentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyToCommentId',
        value: '',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition>
      replyToCommentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'replyToCommentId',
        value: '',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> textContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Comment, Comment, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension CommentQueryObject
    on QueryBuilder<Comment, Comment, QFilterCondition> {
  QueryBuilder<Comment, Comment, QAfterFilterCondition> person(
      FilterQuery<Person> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'person');
    });
  }
}

extension CommentQueryLinks
    on QueryBuilder<Comment, Comment, QFilterCondition> {}

extension CommentQuerySortBy on QueryBuilder<Comment, Comment, QSortBy> {
  QueryBuilder<Comment, Comment, QAfterSortBy> sortByCommentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByCommentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByIsLiked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLiked', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByIsLikedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLiked', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByLikes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'likes', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByLikesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'likes', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByParsedDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parsedDateTime', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByParsedDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parsedDateTime', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByPostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByPostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByReplyToCommentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyToCommentId', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByReplyToCommentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyToCommentId', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension CommentQuerySortThenBy
    on QueryBuilder<Comment, Comment, QSortThenBy> {
  QueryBuilder<Comment, Comment, QAfterSortBy> thenByCommentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByCommentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByIsLiked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLiked', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByIsLikedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLiked', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByLikes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'likes', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByLikesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'likes', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByParsedDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parsedDateTime', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByParsedDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parsedDateTime', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByPostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByPostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByReplyToCommentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyToCommentId', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByReplyToCommentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyToCommentId', Sort.desc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Comment, Comment, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension CommentQueryWhereDistinct
    on QueryBuilder<Comment, Comment, QDistinct> {
  QueryBuilder<Comment, Comment, QDistinct> distinctByCommentId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Comment, Comment, QDistinct> distinctByDateTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Comment, Comment, QDistinct> distinctByIsLiked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isLiked');
    });
  }

  QueryBuilder<Comment, Comment, QDistinct> distinctByLikes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'likes');
    });
  }

  QueryBuilder<Comment, Comment, QDistinct> distinctByParsedDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parsedDateTime');
    });
  }

  QueryBuilder<Comment, Comment, QDistinct> distinctByPostId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'postId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Comment, Comment, QDistinct> distinctByReplyToCommentId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'replyToCommentId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Comment, Comment, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }
}

extension CommentQueryProperty
    on QueryBuilder<Comment, Comment, QQueryProperty> {
  QueryBuilder<Comment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Comment, String, QQueryOperations> commentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commentId');
    });
  }

  QueryBuilder<Comment, String, QQueryOperations> dateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateTime');
    });
  }

  QueryBuilder<Comment, bool, QQueryOperations> isLikedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isLiked');
    });
  }

  QueryBuilder<Comment, int, QQueryOperations> likesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'likes');
    });
  }

  QueryBuilder<Comment, DateTime, QQueryOperations> parsedDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parsedDateTime');
    });
  }

  QueryBuilder<Comment, Person, QQueryOperations> personProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'person');
    });
  }

  QueryBuilder<Comment, String, QQueryOperations> postIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'postId');
    });
  }

  QueryBuilder<Comment, String?, QQueryOperations> replyToCommentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'replyToCommentId');
    });
  }

  QueryBuilder<Comment, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}
