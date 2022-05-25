import 'dart:io';

import 'package:flutter/foundation.dart';

String getExtension(String path) {
  var parts = path.split('.');
  return parts.last;
}

String getFileName(String path) {
  var parts = path.split('/');
  return parts.last;
}

List<File> listAllFiles(
  Directory dir, {
  List<String> extensions = const [],
}) {
  var files = <File>[];
  for (var fileOrDir in dir.listSync()) {
    if (fileOrDir is File) {
      var extension = getExtension(fileOrDir.path);
      if (extensions.contains(extension) || extensions.isEmpty) {
        files.add(fileOrDir);
      }
    } else if (fileOrDir is Directory) {
      try {
        files.addAll(listAllFiles(fileOrDir, extensions: extensions));
      } on Exception {
        debugPrint('Unable to open folder: ${fileOrDir.path}');
      }
    }
  }
  return files;
}

Future<int?> countLines(File file) async {
  var extension = getExtension(file.path);
  if (['png', 'dll'].contains(extension) || extension.length > 5) {
    debugPrint('Invalid extension to count lines: $extension');
    return null;
  }
  var lines = await file.readAsLines();
  return lines.length;
}
