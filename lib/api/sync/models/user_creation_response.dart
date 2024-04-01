import 'package:json_annotation/json_annotation.dart';

part 'user_creation_response.g.dart';

@JsonSerializable()
class UserCreationResponse {
  @JsonKey(name: "message", required: true)
  final String message;

  UserCreationResponse({required this.message});

  factory UserCreationResponse.fromJson(final Map<String, dynamic> json) =>
      _$UserCreationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreationResponseToJson(this);
}
