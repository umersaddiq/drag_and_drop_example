import 'package:drag_and_drop_example/src/base/modals/snack_bar.dart';
import 'package:flutter/material.dart';

import 'base/app_theme.dart';
import 'components/drag_and_drop/drag_and_drop_page.dart';

class DragAndDropApp extends StatelessWidget {
  const DragAndDropApp._({super.key});

  static Future<void> initializeAndRun() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(DragAndDropApp._(key: UniqueKey()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      scaffoldMessengerKey: SnackBarService.scaffoldKey,
      title: 'Drag and Drop',
      home: const DragAndDropPage(),
    );
  }
}
