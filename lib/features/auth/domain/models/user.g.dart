// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      sessionId: json['session_id'] as String?,
      guestSessionId: json['guest_session_id'] as String?,
      isGuest: json['is_guest'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'avatar': instance.avatar,
      'session_id': instance.sessionId,
      'guest_session_id': instance.guestSessionId,
      'is_guest': instance.isGuest,
    };
