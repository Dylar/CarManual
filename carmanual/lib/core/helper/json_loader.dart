import 'dart:convert';
import 'dart:io';

// /// Get a stable path to a test resource by scanning up to the project root.
// Future<File> getProjectFile(String path) async {
//   print("getProjectFile PATH: $path");
//   var dir = Directory.current;
//   print("getProjectFile GEH REIN");
//   await Future.doWhile(() async {
//     print("getProjectFile: $dir");
//     final file = File(dir.path + "/pubspec.yaml");
//     print("file: ${file.path}");
//     final exits = await file.exists();
//     print("EXIST: $exits");
//     if (!exits) {
//       dir = dir.parent;
//     }
//     return exits;
//   });
//   print("getProjectFile LAST: ${dir.path}/$path");
//   return File('${dir.path}/$path');
// }

/// Get a stable path to a test resource by scanning up to the project root.
Future<File> getProjectFile(String path) async {
  var dir = Directory.current;
  while (
      !await dir.list().any((entity) => entity.path.endsWith('pubspec.yaml'))) {
    dir = dir.parent;
  }
  return File('${dir.path}/$path');
}

Future<Map<String, dynamic>> loadJson(String path) async {
  // final file = await getProjectFile(path);
  final file = File(path);
  return jsonDecode(file.readAsStringSync());
}
