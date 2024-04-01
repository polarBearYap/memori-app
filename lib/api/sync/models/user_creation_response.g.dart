// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_creation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCreationResponse _$UserCreationResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['message'],
  );
  return UserCreationResponse(
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$UserCreationResponseToJson(
        UserCreationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
