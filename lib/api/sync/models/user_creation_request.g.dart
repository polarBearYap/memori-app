// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_creation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCreationRequest _$UserCreationRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['email', 'username', 'isEmailVerified'],
  );
  return UserCreationRequest(
    email: json['email'] as String,
    username: json['username'] as String,
    isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  );
}

Map<String, dynamic> _$UserCreationRequestToJson(
        UserCreationRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'isEmailVerified': instance.isEmailVerified,
    };
