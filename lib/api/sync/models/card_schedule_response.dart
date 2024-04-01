import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/converter.dart';

part 'card_schedule_response.g.dart';

/*
{
    "message": "Data validated successfully",
    "data": {
        "1": {
            "card": {
                "difficulty": 0.8662318867398283,
                "due": "2024-02-10T07:56:01Z",
                "elapsed_days": 5,
                "lapses": 3,
                "last_review": "2024-02-10T07:51:01Z",
                "reps": 5,
                "scheduled_days": 0,
                "stability": 0.8864100928217196,
                "state": 1
            },
            "review_log": {
                "elapsed_days": 5,
                "rating": 1,
                "review": "2024-02-10T07:51:01Z",
                "scheduled_days": 0,
                "state": 1
            }
        },
        ... "2", "3", "4"
    }
}
*/
@JsonSerializable()
class CardScheduleResponse {
  @JsonKey(name: 'message', required: true)
  final String message;

  @JsonKey(name: 'data', required: true)
  final Map<String, CardScheduleItem> data;

  CardScheduleResponse({
    required this.message,
    required this.data,
  });

  factory CardScheduleResponse.fromJson(final Map<String, dynamic> json) =>
      _$CardScheduleResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CardScheduleResponseToJson(this);
}

@JsonSerializable()
class CardScheduleItem {
  @JsonKey(name: 'card', required: true)
  final CardInfo card;

  @JsonKey(name: 'review_log', required: true)
  final ReviewLog reviewLog;

  CardScheduleItem({
    required this.card,
    required this.reviewLog,
  });

  factory CardScheduleItem.fromJson(final Map<String, dynamic> json) =>
      _$CardScheduleItemFromJson(json);
  Map<String, dynamic> toJson() => _$CardScheduleItemToJson(this);
}

@JsonSerializable()
class CardInfo {
  @JsonKey(name: 'difficulty', required: true)
  final double difficulty;

  @JsonKey(name: 'due', required: true)
  @CustomDateTimeConverter()
  final DateTime due;

  @JsonKey(name: 'elapsed_days', required: true)
  final int elapsedDays;

  @JsonKey(name: 'lapses', required: true)
  final int lapses;

  @JsonKey(name: 'last_review', required: true)
  @CustomDateTimeConverter()
  final DateTime lastReview;

  @JsonKey(name: 'reps', required: true)
  final int reps;

  @JsonKey(name: 'scheduled_days', required: true)
  final int scheduledDays;

  @JsonKey(name: 'stability', required: true)
  final double stability;

  @JsonKey(name: 'state', required: true)
  final int state;

  CardInfo({
    required this.difficulty,
    required this.due,
    required this.elapsedDays,
    required this.lapses,
    required this.lastReview,
    required this.reps,
    required this.scheduledDays,
    required this.stability,
    required this.state,
  });

  factory CardInfo.fromJson(final Map<String, dynamic> json) =>
      _$CardInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CardInfoToJson(this);
}

@JsonSerializable()
class ReviewLog {
  @JsonKey(name: 'elapsed_days', required: true)
  final int elapsedDays;

  @JsonKey(name: 'rating', required: true)
  final int rating;

  @JsonKey(name: 'review', required: true)
  @CustomDateTimeConverter()
  final DateTime review;

  @JsonKey(name: 'scheduled_days', required: true)
  final int scheduledDays;

  @JsonKey(name: 'state', required: true)
  final int state;

  ReviewLog({
    required this.elapsedDays,
    required this.rating,
    required this.review,
    required this.scheduledDays,
    required this.state,
  });

  factory ReviewLog.fromJson(final Map<String, dynamic> json) =>
      _$ReviewLogFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewLogToJson(this);
}
