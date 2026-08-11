enum Priority {
  low,
  medium,
  high;

  static Priority parse(String value) {
    switch (value.toLowerCase().trim()) {
      case 'high':
      case 'h':
        return Priority.high;
      case 'medium':
      case 'm':
        return Priority.medium;
      case 'low':
      case 'l':
      default:
        return Priority.low;
    }
  }
}