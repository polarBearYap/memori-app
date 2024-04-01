part of 'quill_bloc.dart';

final class CardScreenState extends Equatable {
  const CardScreenState({
    this.isSearchOpened = false,
  });

  final bool isSearchOpened;

  CardScreenState copyWith({
    final bool? isSearchOpened,
  }) =>
      CardScreenState(
        isSearchOpened: isSearchOpened ?? this.isSearchOpened,
      );

  @override
  List<Object> get props => [
        isSearchOpened,
      ];
}
