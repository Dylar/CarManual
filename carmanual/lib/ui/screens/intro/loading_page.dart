import 'package:carmanual/core/app_theme.dart';
import 'package:carmanual/ui/widgets/gradient_text.dart';
import 'package:flutter/material.dart';

class LoadingStartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              BaseColors.primary,
              BaseColors.accent,
            ],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Flexible(
                flex: 3,
                child: GradientText(
                  'qCar',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontWeight: FontWeight.w400),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        BaseColors.babyBlue,
                        BaseColors.zergPurple,
                      ]),
                ),
              ),
              Spacer(flex: 1),
              Flexible(child: CircularProgressIndicator()),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
