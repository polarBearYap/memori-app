part of 'preview_card_bloc.dart';

final class PreviewCardState extends Equatable {
  const PreviewCardState({
    this.stateId = '',
    required this.frontDocument,
    required this.backDocument,
  });

  final String stateId;
  final Document frontDocument;
  final Document backDocument;

  PreviewCardState copyWith({
    final String? stateId,
    final Document? frontDocument,
    final Document? backDocument,
  }) =>
      PreviewCardState(
        stateId: stateId ?? this.stateId,
        frontDocument: frontDocument ?? this.frontDocument,
        backDocument: backDocument ?? this.backDocument,
      );

  @override
  List<Object?> get props => [
        stateId,
        frontDocument,
        backDocument,
      ];
}
