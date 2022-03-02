import 'package:carmanual/core/asset_paths.dart';
import 'package:carmanual/ui/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';

class LoadingStartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loadingUnderChild: true,
      opacity: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(loadingScreenImagePath),
          ),
        ),
      ),
    );
  }
}
