import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class MyDraggableWidget extends StatelessWidget {
  const MyDraggableWidget({
    super.key,
    required this.data,
    required this.child,
    required this.onDragStart,
  });

  final String data;
  final Widget child;
  final void Function() onDragStart;

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      dragItemProvider: (request) {
        onDragStart();
        return DragItem(localData: data);
      },
      dragBuilder: (_, child) => Opacity(opacity: 0.8, child: child),
      allowedOperations: () => [DropOperation.copy],
      child: DraggableWidget(child: child),
    );
  }
}
