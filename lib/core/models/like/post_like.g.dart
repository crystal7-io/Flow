// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_like.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPostLikeCollection on Isar {
  IsarCollection<PostLike> get postLikes => this.collection();
}

const PostLikeSchema = CollectionSchema(
  name: r'PostLike',
  id: -72675558299802220,
  properties: {
    r'createdAt': PropertySchema(id: 0, name: r'createdAt', type: IsarType.dateTime),
    r'postId': PropertySchema(id: 1, name: r'postId', type: IsarType.string),
    r'userId': PropertySchema(id: 2, name: r'userId', type: IsarType.string),
  },
  estimateSize: _postLikeEstimateSize,
  serialize: _postLikeSerialize,
  deserialize: _postLikeDeserialize,
  deserializeProp: _postLikeDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId_postId': IndexSchema(
      id: 3128098513060783924,
      name: r'userId_postId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(name: r'userId', type: IndexType.hash, caseSensitive: true),
        IndexPropertySchema(name: r'postId', type: IndexType.hash, caseSensitive: true),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _postLikeGetId,
  getLinks: _postLikeGetLinks,
  attach: _postLikeAttach,
  version: '3.1.0+1',
);

int _postLikeEstimateSize(PostLike object, List<int> offsets, Map<Type, List<int>> allOffsets) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.postId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _postLikeSerialize(
  PostLike object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.postId);
  writer.writeString(offsets[2], object.userId);
}

PostLike _postLikeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PostLike(
    createdAt: reader.readDateTime(offsets[0]),
    postId: reader.readString(offsets[1]),
    userId: reader.readString(offsets[2]),
  );
  object.id = id;
  return object;
}

P _postLikeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _postLikeGetId(PostLike object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _postLikeGetLinks(PostLike object) {
  return [];
}

void _postLikeAttach(IsarCollection<dynamic> col, Id id, PostLike object) {
  object.id = id;
}

extension PostLikeByIndex on IsarCollection<PostLike> {
  Future<PostLike?> getByUserIdPostId(String userId, String postId) {
    return getByIndex(r'userId_postId', [userId, postId]);
  }

  PostLike? getByUserIdPostIdSync(String userId, String postId) {
    return getByIndexSync(r'userId_postId', [userId, postId]);
  }

  Future<bool> deleteByUserIdPostId(String userId, String postId) {
    return deleteByIndex(r'userId_postId', [userId, postId]);
  }

  bool deleteByUserIdPostIdSync(String userId, String postId) {
    return deleteByIndexSync(r'userId_postId', [userId, postId]);
  }

  Future<List<PostLike?>> getAllByUserIdPostId(
    List<String> userIdValues,
    List<String> postIdValues,
  ) {
    final len = userIdValues.length;
    assert(postIdValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([userIdValues[i], postIdValues[i]]);
    }

    return getAllByIndex(r'userId_postId', values);
  }

  List<PostLike?> getAllByUserIdPostIdSync(List<String> userIdValues, List<String> postIdValues) {
    final len = userIdValues.length;
    assert(postIdValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([userIdValues[i], postIdValues[i]]);
    }

    return getAllByIndexSync(r'userId_postId', values);
  }

  Future<int> deleteAllByUserIdPostId(List<String> userIdValues, List<String> postIdValues) {
    final len = userIdValues.length;
    assert(postIdValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([userIdValues[i], postIdValues[i]]);
    }

    return deleteAllByIndex(r'userId_postId', values);
  }

  int deleteAllByUserIdPostIdSync(List<String> userIdValues, List<String> postIdValues) {
    final len = userIdValues.length;
    assert(postIdValues.length == len, 'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([userIdValues[i], postIdValues[i]]);
    }

    return deleteAllByIndexSync(r'userId_postId', values);
  }

  Future<Id> putByUserIdPostId(PostLike object) {
    return putByIndex(r'userId_postId', object);
  }

  Id putByUserIdPostIdSync(PostLike object, {bool saveLinks = true}) {
    return putByIndexSync(r'userId_postId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUserIdPostId(List<PostLike> objects) {
    return putAllByIndex(r'userId_postId', objects);
  }

  List<Id> putAllByUserIdPostIdSync(List<PostLike> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'userId_postId', objects, saveLinks: saveLinks);
  }
}

extension PostLikeQueryWhereSort on QueryBuilder<PostLike, PostLike, QWhere> {
  QueryBuilder<PostLike, PostLike, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PostLikeQueryWhere on QueryBuilder<PostLike, PostLike, QWhereClause> {
  QueryBuilder<PostLike, PostLike, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: false))
            .addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: false));
      } else {
        return query
            .addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: false))
            .addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: false));
      }
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.greaterThan(lower: id, includeLower: include));
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.lessThan(upper: id, includeUpper: include));
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterWhereClause> userIdEqualToAnyPostId(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId_postId', value: [userId]),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterWhereClause> userIdNotEqualToAnyPostId(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId_postId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId_postId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId_postId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId_postId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterWhereClause> userIdPostIdEqualTo(
    String userId,
    String postId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId_postId', value: [userId, postId]),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterWhereClause> userIdEqualToPostIdNotEqualTo(
    String userId,
    String postId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId_postId',
                lower: [userId],
                upper: [userId, postId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId_postId',
                lower: [userId, postId],
                includeLower: false,
                upper: [userId],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId_postId',
                lower: [userId, postId],
                includeLower: false,
                upper: [userId],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId_postId',
                lower: [userId],
                upper: [userId, postId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension PostLikeQueryFilter on QueryBuilder<PostLike, PostLike, QFilterCondition> {
  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'id', value: value));
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(include: include, property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(include: include, property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> postIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'postId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> postIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'postId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> postIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'postId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> postIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'postId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> postIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'postId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> postIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'postId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> postIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'postId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> postIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'postId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> postIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'postId', value: ''));
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> postIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'postId', value: ''));
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(property: r'userId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(property: r'userId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> userIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(property: r'userId', value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> userIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(property: r'userId', value: ''));
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(property: r'userId', value: ''));
    });
  }
}

extension PostLikeQueryObject on QueryBuilder<PostLike, PostLike, QFilterCondition> {}

extension PostLikeQueryLinks on QueryBuilder<PostLike, PostLike, QFilterCondition> {}

extension PostLikeQuerySortBy on QueryBuilder<PostLike, PostLike, QSortBy> {
  QueryBuilder<PostLike, PostLike, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> sortByPostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.asc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> sortByPostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.desc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PostLikeQuerySortThenBy on QueryBuilder<PostLike, PostLike, QSortThenBy> {
  QueryBuilder<PostLike, PostLike, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> thenByPostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.asc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> thenByPostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.desc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PostLike, PostLike, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PostLikeQueryWhereDistinct on QueryBuilder<PostLike, PostLike, QDistinct> {
  QueryBuilder<PostLike, PostLike, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PostLike, PostLike, QDistinct> distinctByPostId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'postId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PostLike, PostLike, QDistinct> distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension PostLikeQueryProperty on QueryBuilder<PostLike, PostLike, QQueryProperty> {
  QueryBuilder<PostLike, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PostLike, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PostLike, String, QQueryOperations> postIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'postId');
    });
  }

  QueryBuilder<PostLike, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
