part of 'preview_card_bloc.dart';

sealed class PreviewCardEvent extends Equatable {
  const PreviewCardEvent();

  @override
  List<Object> get props => [];
}

final class PreviewCardOpened extends PreviewCardEvent {
  const PreviewCardOpened({
    required this.frontDocument,
    required this.backDocument,
  });

  final Document frontDocument;
  final Document backDocument;

  @override
  List<Object> get props => [
        frontDocument,
        backDocument,
      ];
}
