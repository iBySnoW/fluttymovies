// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String? get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'guest_session_id')
  String? get guestSessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_guest')
  bool get isGuest => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String username,
      String? email,
      String? avatar,
      @JsonKey(name: 'session_id') String? sessionId,
      @JsonKey(name: 'guest_session_id') String? guestSessionId,
      @JsonKey(name: 'is_guest') bool isGuest});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? sessionId = freezed,
    Object? guestSessionId = freezed,
    Object? isGuest = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      guestSessionId: freezed == guestSessionId
          ? _value.guestSessionId
          : guestSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      isGuest: null == isGuest
          ? _value.isGuest
          : isGuest // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String username,
      String? email,
      String? avatar,
      @JsonKey(name: 'session_id') String? sessionId,
      @JsonKey(name: 'guest_session_id') String? guestSessionId,
      @JsonKey(name: 'is_guest') bool isGuest});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? sessionId = freezed,
    Object? guestSessionId = freezed,
    Object? isGuest = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      guestSessionId: freezed == guestSessionId
          ? _value.guestSessionId
          : guestSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      isGuest: null == isGuest
          ? _value.isGuest
          : isGuest // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.username,
      this.email,
      this.avatar,
      @JsonKey(name: 'session_id') this.sessionId,
      @JsonKey(name: 'guest_session_id') this.guestSessionId,
      @JsonKey(name: 'is_guest') this.isGuest = false});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String? email;
  @override
  final String? avatar;
  @override
  @JsonKey(name: 'session_id')
  final String? sessionId;
  @override
  @JsonKey(name: 'guest_session_id')
  final String? guestSessionId;
  @override
  @JsonKey(name: 'is_guest')
  final bool isGuest;

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, avatar: $avatar, sessionId: $sessionId, guestSessionId: $guestSessionId, isGuest: $isGuest)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.guestSessionId, guestSessionId) ||
                other.guestSessionId == guestSessionId) &&
            (identical(other.isGuest, isGuest) || other.isGuest == isGuest));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, email, avatar,
      sessionId, guestSessionId, isGuest);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String username,
      final String? email,
      final String? avatar,
      @JsonKey(name: 'session_id') final String? sessionId,
      @JsonKey(name: 'guest_session_id') final String? guestSessionId,
      @JsonKey(name: 'is_guest') final bool isGuest}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String? get email;
  @override
  String? get avatar;
  @override
  @JsonKey(name: 'session_id')
  String? get sessionId;
  @override
  @JsonKey(name: 'guest_session_id')
  String? get guestSessionId;
  @override
  @JsonKey(name: 'is_guest')
  bool get isGuest;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
