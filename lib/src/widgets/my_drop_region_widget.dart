import 'dart:convert';

import 'package:drag_and_drop_example/src/base/modals/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../utils/const.dart';

class MyDropRegion extends StatefulWidget {
  const MyDropRegion({
    super.key,
    required this.childSize,
    required this.columns,
    required this.panel,
    required this.updateDropPreview,
    required this.child,
    required this.onDrop,
    required this.setExternalData,
  });

  final Size childSize;
  final int columns;
  final Panel panel;
  final void Function(PanelLocation) updateDropPreview;
  final void Function(String) setExternalData;
  final Widget child;
  final VoidCallback onDrop;

  @override
  State<MyDropRegion> createState() => _MyDropRegionState();
}

class _MyDropRegionState extends State<MyDropRegion> {
  int? dropIndex;

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: Formats.standardFormats,
      onDropOver: (event) {
        _updatePreview(event.position.local);
        return DropOperation.copy;
      },
      onPerformDrop: (event) async {
        widget.onDrop();
      },
      onDropEnter: (event) {
        /// Dragging TextFiles From Explorer
        final dataReader = event.session.items.first.dataReader;
        if (dataReader != null) {
          if (!dataReader.canProvide(Formats.plainTextFile)) {
            SnackBarService.showSnackBar('File Type not Supported!');
            return;
          }
          dataReader.getFile(Formats.plainTextFile, (value) async {
            widget.setExternalData(utf8.decode(await value.readAll()));
          });
        }
      },
      child: widget.child,
    );
  }

  void _updatePreview(Offset hoverPosition) {
    final row = hoverPosition.dy ~/ widget.childSize.height;
    final column = (hoverPosition.dx - (widget.childSize.width / 2)) ~/
        widget.childSize.width;
    final newDropIndex = (row * widget.columns) + column;
    if (newDropIndex != dropIndex) {
      dropIndex = newDropIndex;
      widget.updateDropPreview((index: dropIndex!, panel: widget.panel));
    }
  }
}
