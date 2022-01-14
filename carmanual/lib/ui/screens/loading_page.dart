import 'package:carmanual/ui/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';

import '../../core/asset_paths.dart';

class LoadingStartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      opacity: OPACITY_20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(loadingImagePath),
          ),
        ),
      ),
    );
  }
}
