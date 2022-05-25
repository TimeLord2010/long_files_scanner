import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:long_files_scanner/models/file_count.dart';
import 'package:long_files_scanner/utils/file.dart';

class MainPageProvider with ChangeNotifier {
  final folderController = TextEditingController();
  final extensionsController = TextEditingController();
  List<File> pendingFiles = [];
  int totalFiles = 0;

  List<FileCount> fileLines = [];

  bool _isScanning = false;
  bool get isScanning => _isScanning;
  set isScanning(bool isScanning) {
    _isScanning = isScanning;
    notifyListeners();
  }

  double get progress {
    if (totalFiles == 0 || pendingFiles.isEmpty) {
      return 0;
    }
    var value = (pendingFiles.length * 100) / totalFiles;
    return 100 - value;
  }

  void scanFiles() async {
    if (isScanning) {
      return;
    }
    isScanning = true;
    pendingFiles = [];
    fileLines.clear();
    totalFiles = 0;
    try {
      var pickedDir = Directory(folderController.text);
      if (!pickedDir.existsSync()) {
        return;
      }
      pendingFiles = listAllFiles(pickedDir, extensions: getExtensions());
      totalFiles = pendingFiles.length;
      notifyListeners();
      while (pendingFiles.isNotEmpty) {
        var file = pendingFiles.removeAt(0);
        try {
          var lines = await countLines(file);
          if (lines == null) {
            continue;
          }
          fileLines.add(FileCount(file.path, lines));
        } on Exception catch (e) {
          debugPrint(e.toString());
        }
        notifyListeners();
      }
      fileLines.sort((a, b) => (b.count ?? -1).compareTo(a.count ?? -1));
      notifyListeners();
    } finally {
      isScanning = false;
    }
  }

  List<String> getExtensions() {
    var value = extensionsController.text;
    if (value.isEmpty || value == '*') {
      return [];
    } else {
      return value.replaceAll(' ', '').split(',');
    }
  }

  String filterDirPath(String filePath) {
    var dir = folderController.text;
    return filePath.replaceFirst(dir, '');
  }

  void browseFolder() async {
    var result = await FilePicker.platform.getDirectoryPath();
    if (result == null) {
      return;
    }
    folderController.text = result;
  }
}
