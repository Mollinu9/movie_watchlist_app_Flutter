enum MovieStatus {
  toWatch,
  watched;

  String get displayName {
    switch (this) {
      case MovieStatus.toWatch:
        return 'To Watch';
      case MovieStatus.watched:
        return 'Watched';
    }
  }
}
