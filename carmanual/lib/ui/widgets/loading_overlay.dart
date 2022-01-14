import 'package:carmanual/core/app_theme.dart';
import 'package:flutter/material.dart';

const OPACITY_20 = .2;
const OPACITY_100 = 1.0;

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    this.backgroundColor = BaseColors.veryVeryLightGrey,
    this.opacity = OPACITY_100,
    this.child,
  });

  final Color backgroundColor;
  final double opacity;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (child != null) child!,
        Container(
            color: backgroundColor.withOpacity(opacity),
            child: const Center(child: CircularProgressIndicator())),
      ],
    );
  }
}
