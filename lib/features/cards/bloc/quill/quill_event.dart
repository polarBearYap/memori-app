part of 'quill_bloc.dart';

sealed class CardScreenEvent extends Equatable {
  const CardScreenEvent();

  @override
  List<Object> get props => [];
}

final class SearchOpened extends CardScreenEvent {}

final class SearchClosed extends CardScreenEvent {}
