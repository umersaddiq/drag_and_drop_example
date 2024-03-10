import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/const.dart';
import 'item_panel_widget.dart';
import 'my_drop_region_widget.dart';

class SplitPanelWidget extends StatefulWidget {
  const SplitPanelWidget({
    super.key,
    this.columns = 5,
    this.itemSpacing = 4.0,
  });

  final int columns;
  final double itemSpacing;

  @override
  State<SplitPanelWidget> createState() => _SplitPanelWidgetState();
}

class _SplitPanelWidgetState extends State<SplitPanelWidget> {
  final upper = <String>[];
  final lower = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];

  PanelLocation? dragStart;
  PanelLocation? dropPreview;
  String? hoveringData;

  void _onDragStart(PanelLocation start) {
    final data = switch (start.panel) {
      Panel.lower => lower[start.index],
      Panel.upper => upper[start.index]
    };
    dragStart = start;
    hoveringData = data;
    setState(() {});
  }

  void drop() {
    assert(dropPreview != null, 'Can only drop over a known location.');
    assert(hoveringData != null, 'Can only drop when data is being dragged');
    if (dragStart != null) {
      if (dragStart?.panel == Panel.upper) {
        upper.removeAt(dragStart!.index);
      } else {
        lower.removeAt(dragStart!.index);
      }
    }

    if (dropPreview?.panel == Panel.upper) {
      upper.insert(min(dropPreview!.index, upper.length), hoveringData ?? '');
    } else {
      lower.insert(min(dropPreview!.index, lower.length), hoveringData ?? '');
    }
    dragStart = null;
    dropPreview = null;
    hoveringData = null;

    setState(() {});
  }

  void setExternalData(String data) {
    hoveringData = data;
  }

  void updateDropPreview(PanelLocation update) {
    dropPreview = update;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      final gutters = widget.columns + 1;
      final spaceForColumns = c.maxWidth - (widget.itemSpacing * gutters);
      final columnWidth = spaceForColumns / widget.columns;
      final itemSize = Size(columnWidth, columnWidth);
      return Stack(children: [
        Positioned(
          height: c.maxHeight / 2,
          width: c.maxWidth,
          top: 0,
          child: MyDropRegion(
            onDrop: drop,
            setExternalData: setExternalData,
            updateDropPreview: updateDropPreview,
            columns: widget.columns,
            childSize: itemSize,
            panel: Panel.upper,
            child: ItemPanelWidget(
              crossAxisCount: widget.columns,
              spacing: widget.itemSpacing,
              items: upper,
              dragStart: dragStart?.panel == Panel.upper ? dragStart : null,
              onDragStart: _onDragStart,
              panel: Panel.upper,
              dropPreview:
                  dropPreview?.panel == Panel.upper ? dropPreview : null,
              hoveringData:
                  dropPreview?.panel == Panel.upper ? hoveringData : null,
            ),
          ),
        ),
        Positioned(
          height: 2,
          width: c.maxWidth,
          top: c.maxHeight / 2,
          child: const ColoredBox(color: Colors.black),
        ),
        Positioned(
          height: c.maxHeight / 2,
          width: c.maxWidth,
          bottom: 0,
          child: MyDropRegion(
            onDrop: drop,
            setExternalData: setExternalData,
            updateDropPreview: updateDropPreview,
            columns: widget.columns,
            childSize: itemSize,
            panel: Panel.lower,
            child: ItemPanelWidget(
              dragStart: dragStart?.panel == Panel.lower ? dragStart : null,
              crossAxisCount: widget.columns,
              spacing: widget.itemSpacing,
              items: lower,
              onDragStart: _onDragStart,
              panel: Panel.lower,
              dropPreview:
                  dropPreview?.panel == Panel.lower ? dropPreview : null,
              hoveringData:
                  dropPreview?.panel == Panel.lower ? hoveringData : null,
            ),
          ),
        ),
      ]);
    });
  }
}
