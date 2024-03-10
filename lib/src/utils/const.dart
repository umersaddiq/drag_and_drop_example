enum Panel { upper, lower }

typedef PanelLocation = ({int index, Panel panel});

extension CopyablePanelLocation on PanelLocation {
  PanelLocation copyWith({int? index, Panel? panel}) {
    return (index: index ?? this.index, panel: panel ?? this.panel);
  }
}
