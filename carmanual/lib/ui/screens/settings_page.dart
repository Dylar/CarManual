import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return ValueListenableBuilder(
    //   valueListenable: Hive.box('settings').listenable(),
    //   builder: (context, box, widget) {
    //     return Switch(
    //         value: box.get('darkMode'),
    //         onChanged: (val) {
    //           box.put('darkMode', val);
    //         });
    //   },
    // );
  }
}
