import 'package:flutter/material.dart';

import '../../widgets/split_panel_widget.dart';

class DragAndDropPage extends StatefulWidget {
  const DragAndDropPage({super.key});

  @override
  State<DragAndDropPage> createState() => _DragAndDropPageState();
}

class _DragAndDropPageState extends State<DragAndDropPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drag and Drop')),
      body: const SplitPanelWidget(),
    );
  }
}
