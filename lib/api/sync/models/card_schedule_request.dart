import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/converter.dart';

part 'card_schedule_request.g.dart';

@JsonSerializable()
class CardScheduleRequest {
  /*
  {
      "difficulty": 0.8662318867398283,
      "due": "2024-02-10T07:56:01Z",
      "elapsed_days": 5,
      "lapses": 3,
      "last_review": "2024-02-10T07:51:01Z",
      "reps": 5,
      "scheduled_days": 0,
      "stability": 0.8864100928217196,
      "state": 1,
      "current_review": "2024-02-10T07:56:01Z"
  }
  */

  /*
  {
    'due': datetime.datetime(2024, 3, 5, 23, 9, 11, 718878), 
    'stability': 0, 
    'difficulty': 0, 
    'elapsed_days': 0, 
    'scheduled_days': 0, 
    'reps': 0, 
    'lapses': 0, 
    'state': <State.New: 0>
  }
   */

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

  @JsonKey(name: 'current_review', required: true)
  @CustomDateTimeConverter()
  final DateTime currentReview;

  CardScheduleRequest({
    required this.difficulty,
    required this.due,
    required this.elapsedDays,
    required this.lapses,
    required this.lastReview,
    required this.reps,
    required this.scheduledDays,
    required this.stability,
    required this.state,
    required this.currentReview,
  });

  factory CardScheduleRequest.fromJson(final Map<String, dynamic> json) =>
      _$CardScheduleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CardScheduleRequestToJson(this);
}
