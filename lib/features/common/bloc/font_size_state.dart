part of 'font_size_bloc.dart';

class FontSizeState extends Equatable {
  final double scaleFactor;
  final double sliderValue;
  final FontSizeScaleFactor factorDesc;

  const FontSizeState({
    this.scaleFactor = 1.0,
    this.sliderValue = 1.0,
    this.factorDesc = FontSizeScaleFactor.normal,
  });

  FontSizeState copyWith({
    final double? scaleFactor,
    final double? sliderValue,
    final FontSizeScaleFactor? factorDesc,
  }) =>
      FontSizeState(
        scaleFactor: scaleFactor ?? this.scaleFactor,
        sliderValue: sliderValue ?? this.sliderValue,
        factorDesc: factorDesc ?? this.factorDesc,
      );

  @override
  List<Object> get props => [
        scaleFactor,
        sliderValue,
        factorDesc,
      ];
}
