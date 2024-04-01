part of 'font_size_bloc.dart';

sealed class FontSizeEvent extends Equatable {
  const FontSizeEvent();

  @override
  List<Object> get props => [];
}

final class ScaleFactorChanged extends FontSizeEvent {
  final double scaleFactor;

  const ScaleFactorChanged({required this.scaleFactor});

  @override
  List<Object> get props => [scaleFactor];
}
