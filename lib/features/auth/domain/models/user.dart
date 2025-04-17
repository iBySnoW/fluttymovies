import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String username,
    String? avatar,
    @JsonKey(name: 'session_id') String? sessionId,
    @JsonKey(name: 'guest_session_id') String? guestSessionId,
    @JsonKey(name: 'is_guest') @Default(false) bool isGuest,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
} 