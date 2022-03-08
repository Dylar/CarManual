import 'package:carmanual/core/app_theme.dart';
import 'package:carmanual/ui/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/constants/debug.dart';

class DirListItem extends StatelessWidget {
  const DirListItem(this.dirName);

  final String dirName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lowerDir = dirName.toLowerCase();
    String? categorieText;
    if (lowerDir.contains("sicherheit")) {
      categorieText = l10n.sicherheit;
    } else if (lowerDir.contains("ambiente")) {
      categorieText = l10n.multimedia;
    } else if (lowerDir.contains("ausstattungslinie")) {
      categorieText = l10n.komfort;
    } else if (lowerDir.contains("assistenz")) {
      categorieText = l10n.komfort;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: BaseColors.babyBlue),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: CarInfoPic(DEBUG_PIC_URL)),
            Spacer(flex: 5),
            Expanded(
              flex: 95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${dirName.replaceAll("/", "").replaceAll("_", " ")}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  if (categorieText != null)
                    Divider(color: BaseColors.zergPurple),
                  if (categorieText != null)
                    Text(
                      categorieText,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarInfoPic extends StatelessWidget {
  const CarInfoPic(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      child: Image.network(
        url,
        loadingBuilder: loadingWidget,
        errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
        ) =>
            ErrorInfoWidget("Error"),
      ),
    );
  }

  Widget loadingWidget(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  }
}
