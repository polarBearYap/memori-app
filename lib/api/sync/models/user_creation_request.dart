import 'package:json_annotation/json_annotation.dart';

part 'user_creation_request.g.dart';

@JsonSerializable()
class UserCreationRequest {
  @JsonKey(name: 'email', required: true)
  final String email;

  @JsonKey(name: 'username', required: true)
  final String username;

  @JsonKey(name: 'isEmailVerified', required: true, defaultValue: false)
  final bool isEmailVerified;

  UserCreationRequest(
      {required this.email,
      required this.username,
      required this.isEmailVerified,});

  factory UserCreationRequest.fromJson(final Map<String, dynamic> json) =>
      _$UserCreationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreationRequestToJson(this);
}
