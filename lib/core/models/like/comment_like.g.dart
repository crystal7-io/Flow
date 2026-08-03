// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_like.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCommentLikeCollection on Isar {
  IsarCollection<CommentLike> get commentLikes => this.collection();
}

const CommentLikeSchema = CollectionSchema(
  name: r'CommentLike',
  id: 2846247671930443092,
  properties: {
    r'commentId': PropertySchema(
      id: 0,
      name: r'commentId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 2,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _commentLikeEstimateSize,
  serialize: _commentLikeSerialize,
  deserialize: _commentLikeDeserialize,
  deserializeProp: _commentLikeDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId_commentId': IndexSchema(
      id: -3078647373991164940,
      name: r'userId_commentId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'commentId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _commentLikeGetId,
  getLinks: _commentLikeGetLinks,
  attach: _commentLikeAttach,
  version: '3.1.0+1',
);

int _commentLikeEstimateSize(
  CommentLike object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.commentId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _commentLikeSerialize(
  CommentLike object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.commentId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.userId);
}

CommentLike _commentLikeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CommentLike(
    commentId: reader.readString(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    userId: reader.readString(offsets[2]),
  );
  object.id = id;
  return object;
}

P _commentLikeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _commentLikeGetId(CommentLike object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _commentLikeGetLinks(CommentLike object) {
  return [];
}

void _commentLikeAttach(
    IsarCollection<dynamic> col, Id id, CommentLike object) {
  object.id = id;
}

extension CommentLikeByIndex on IsarCollection<CommentLike> {
  Future<CommentLike?> getByUserIdCommentId(String userId, String commentId) {
    return getByIndex(r'userId_commentId', [userId, commentId]);
  }

  CommentLike? getByUserIdCommentIdSync(String userId, String commentId) {
    return getByIndexSync(r'userId_commentId', [userId, commentId]);
  }

  Future<bool> deleteByUserIdCommentId(String userId, String commentId) {
    return deleteByIndex(r'userId_commentId', [userId, commentId]);
  }

  bool deleteByUserIdCommentIdSync(String userId, String commentId) {
    return deleteByIndexSync(r'userId_commentId', [userId, commentId]);
  }

  Future<List<CommentLike?>> getAllByUserIdCommentId(
      List<String> userIdValues, List<String> commentIdValues) {
    final len = userIdValues.length;
    assert(commentIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([userIdValues[i], commentIdValues[i]]);
    }

    return getAllByIndex(r'userId_commentId', values);
  }

  List<CommentLike?> getAllByUserIdCommentIdSync(
      List<String> userIdValues, List<String> commentIdValues) {
    final len = userIdValues.length;
    assert(commentIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([userIdValues[i], commentIdValues[i]]);
    }

    return getAllByIndexSync(r'userId_commentId', values);
  }

  Future<int> deleteAllByUserIdCommentId(
      List<String> userIdValues, List<String> commentIdValues) {
    final len = userIdValues.length;
    assert(commentIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([userIdValues[i], commentIdValues[i]]);
    }

    return deleteAllByIndex(r'userId_commentId', values);
  }

  int deleteAllByUserIdCommentIdSync(
      List<String> userIdValues, List<String> commentIdValues) {
    final len = userIdValues.length;
    assert(commentIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([userIdValues[i], commentIdValues[i]]);
    }

    return deleteAllByIndexSync(r'userId_commentId', values);
  }

  Future<Id> putByUserIdCommentId(CommentLike object) {
    return putByIndex(r'userId_commentId', object);
  }

  Id putByUserIdCommentIdSync(CommentLike object, {bool saveLinks = true}) {
    return putByIndexSync(r'userId_commentId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUserIdCommentId(List<CommentLike> objects) {
    return putAllByIndex(r'userId_commentId', objects);
  }

  List<Id> putAllByUserIdCommentIdSync(List<CommentLike> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'userId_commentId', objects,
        saveLinks: saveLinks);
  }
}

extension CommentLikeQueryWhereSort
    on QueryBuilder<CommentLike, CommentLike, QWhere> {
  QueryBuilder<CommentLike, CommentLike, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CommentLikeQueryWhere
    on QueryBuilder<CommentLike, CommentLike, QWhereClause> {
  QueryBuilder<CommentLike, CommentLike, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<CommentLike, CommentLike, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterWhereClause> idBetween(
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

  QueryBuilder<CommentLike, CommentLike, QAfterWhereClause>
      userIdEqualToAnyCommentId(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId_commentId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterWhereClause>
      userIdNotEqualToAnyCommentId(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId_commentId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId_commentId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId_commentId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId_commentId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterWhereClause>
      userIdCommentIdEqualTo(String userId, String commentId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId_commentId',
        value: [userId, commentId],
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterWhereClause>
      userIdEqualToCommentIdNotEqualTo(String userId, String commentId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId_commentId',
              lower: [userId],
              upper: [userId, commentId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId_commentId',
              lower: [userId, commentId],
              includeLower: false,
              upper: [userId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId_commentId',
              lower: [userId, commentId],
              includeLower: false,
              upper: [userId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId_commentId',
              lower: [userId],
              upper: [userId, commentId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CommentLikeQueryFilter
    on QueryBuilder<CommentLike, CommentLike, QFilterCondition> {
  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      commentIdEqualTo(
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

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      commentIdGreaterThan(
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

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      commentIdLessThan(
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

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      commentIdBetween(
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

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      commentIdStartsWith(
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

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      commentIdEndsWith(
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

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      commentIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      commentIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      commentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      commentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commentId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension CommentLikeQueryObject
    on QueryBuilder<CommentLike, CommentLike, QFilterCondition> {}

extension CommentLikeQueryLinks
    on QueryBuilder<CommentLike, CommentLike, QFilterCondition> {}

extension CommentLikeQuerySortBy
    on QueryBuilder<CommentLike, CommentLike, QSortBy> {
  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> sortByCommentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.asc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> sortByCommentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.desc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension CommentLikeQuerySortThenBy
    on QueryBuilder<CommentLike, CommentLike, QSortThenBy> {
  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> thenByCommentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.asc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> thenByCommentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.desc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension CommentLikeQueryWhereDistinct
    on QueryBuilder<CommentLike, CommentLike, QDistinct> {
  QueryBuilder<CommentLike, CommentLike, QDistinct> distinctByCommentId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommentLike, CommentLike, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CommentLike, CommentLike, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension CommentLikeQueryProperty
    on QueryBuilder<CommentLike, CommentLike, QQueryProperty> {
  QueryBuilder<CommentLike, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CommentLike, String, QQueryOperations> commentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commentId');
    });
  }

  QueryBuilder<CommentLike, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CommentLike, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
