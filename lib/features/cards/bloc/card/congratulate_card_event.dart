part of 'congratulate_card_bloc.dart';

sealed class CongratulateCardEvent extends Equatable {
  const CongratulateCardEvent();

  @override
  List<Object?> get props => [];
}

final class CongratulateCardInit extends CongratulateCardEvent {
  const CongratulateCardInit();
}
