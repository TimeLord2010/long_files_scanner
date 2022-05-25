import 'package:flutter/cupertino.dart';
import 'package:long_files_scanner/ui/main_page.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'Flutter Demo',
      home: MacosScaffold(
        children: [
          ContentArea(
            builder: (context, scrollController) {
              return const Padding(
                padding: EdgeInsets.all(8),
                child: MainPage(),
              );
            },
          ),
        ],
      ),
    );
  }
}
