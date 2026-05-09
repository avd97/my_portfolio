import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {

  final Color serviceCardBg;
  final Color serviceCardBorder;

  final Color selectedServiceBg;

  final List<Color> serviceButtonGradient;

  const CustomColors({
    required this.serviceCardBg,
    required this.serviceCardBorder,
    required this.selectedServiceBg,
    required this.serviceButtonGradient,
  });

  @override
  CustomColors copyWith({
    Color? serviceCardBg,
    Color? serviceCardBorder,
    Color? selectedServiceBg,
    List<Color>? serviceButtonGradient,
  }) {
    return CustomColors(
      serviceCardBg:
      serviceCardBg ?? this.serviceCardBg,

      serviceCardBorder:
      serviceCardBorder ?? this.serviceCardBorder,

      selectedServiceBg:
      selectedServiceBg ?? this.selectedServiceBg,

      serviceButtonGradient:
      serviceButtonGradient ??
          this.serviceButtonGradient,
    );
  }

  @override
  CustomColors lerp(
      ThemeExtension<CustomColors>? other,
      double t,
      ) {
    if (other is! CustomColors) {
      return this;
    }

    return CustomColors(
      serviceCardBg: Color.lerp(
        serviceCardBg,
        other.serviceCardBg,
        t,
      )!,

      serviceCardBorder: Color.lerp(
        serviceCardBorder,
        other.serviceCardBorder,
        t,
      )!,

      selectedServiceBg: Color.lerp(
        selectedServiceBg,
        other.selectedServiceBg,
        t,
      )!,

      serviceButtonGradient: [
        Color.lerp(
          serviceButtonGradient[0],
          other.serviceButtonGradient[0],
          t,
        )!,

        Color.lerp(
          serviceButtonGradient[1],
          other.serviceButtonGradient[1],
          t,
        )!,

        Color.lerp(
          serviceButtonGradient[2],
          other.serviceButtonGradient[2],
          t,
        )!,
      ],
    );
  }
}