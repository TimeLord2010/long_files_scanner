import 'package:flutter/cupertino.dart';
import 'package:long_files_scanner/ui/main_page_provider.dart';
import 'package:long_files_scanner/utils/file.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainPageProvider(),
      child: Consumer<MainPageProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
              Row(
                children: [
                  const Text('Extensions'),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 150,
                    child: MacosTextField(
                      controller: value.extensionsController,
                      placeholder: 'dart, py, cs, ...',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text('Folder'),
                  const SizedBox(width: 40),
                  Expanded(
                    child: MacosTextField(
                      placeholder: 'Folder path...',
                      controller: value.folderController,
                    ),
                  ),
                  const SizedBox(width: 5),
                  PushButton(
                    buttonSize: ButtonSize.small,
                    onPressed: value.browseFolder,
                    child: const Text('Browse'),
                  ),
                  const SizedBox(width: 5),
                  PushButton(
                    buttonSize: ButtonSize.large,
                    onPressed: value.isScanning ? null : value.scanFiles,
                    child: const Text('Scan'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getSummary(value),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: value.fileLines.length,
                  itemBuilder: (context, index) {
                    var item = value.fileLines[index];
                    var filePath = value.filterDirPath(item.file);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 12, 4),
                      child: Row(
                        children: [
                          MacosTooltip(
                            message: filePath,
                            child: Text(getFileName(filePath)),
                          ),
                          const Spacer(),
                          Text('${item.count}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget getSummary(MainPageProvider value) {
    if (value.isScanning) {
      return ProgressBar(
        value: value.progress,
      );
    } else {
      return Text('Files: ${value.fileLines.length}');
    }
  }
}
