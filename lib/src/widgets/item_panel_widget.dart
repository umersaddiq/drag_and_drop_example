import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

import '../utils/const.dart';
import 'my_draggable_widget.dart';

class ItemPanelWidget extends StatelessWidget {
  const ItemPanelWidget({
    super.key,
    required this.crossAxisCount,
    required this.items,
    required this.spacing,
    required this.onDragStart,
    required this.dragStart,
    required this.panel,
    required this.dropPreview,
    required this.hoveringData,
  });

  final int crossAxisCount;
  final List<String> items;
  final double spacing;
  final void Function(PanelLocation) onDragStart;
  final Panel panel;
  final PanelLocation? dragStart;
  final PanelLocation? dropPreview;
  final String? hoveringData;

  @override
  Widget build(BuildContext context) {
    final itemsCopy = List<String>.from(items);
    PanelLocation? dragStartCopy;
    PanelLocation? dropPreviewCopy;
    if (dragStart != null) {
      dragStartCopy = dragStart!.copyWith();
    }
    if (dropPreview != null && hoveringData != null) {
      dropPreviewCopy = dropPreview!.copyWith(
        index: min(items.length, dropPreview?.index ?? 0),
      );
      if (dragStartCopy?.panel == dropPreviewCopy.panel) {
        itemsCopy.removeAt(dragStartCopy!.index);
        dragStartCopy = null;
      }
      itemsCopy.insert(
        min(dropPreview!.index, itemsCopy.length),
        hoveringData!,
      );
    }
    return GridView.count(
      crossAxisCount: crossAxisCount,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: itemsCopy.asMap().entries.map((e) {
        final textColor =
            e.key == dragStartCopy?.index || e.key == dropPreviewCopy?.index
                ? Colors.grey
                : Colors.white;
        Widget child = Center(
          child: Text(
            e.value,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 36, color: textColor),
          ),
        );

        if (e.key == dragStartCopy?.index) {
          child = Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          );
        } else if (e.key == dropPreviewCopy?.index) {
          child = DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            dashPattern: const [10, 10],
            color: Colors.grey,
            strokeWidth: 2,
            child: child,
          );
        } else {
          child = Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            child: child,
          );
        }
        return Draggable(
          feedback: child,
          child: MyDraggableWidget(
            data: e.value,
            onDragStart: () => onDragStart((index: e.key, panel: panel)),
            child: child,
          ),
        );
      }).toList(),
    );
  }
}
