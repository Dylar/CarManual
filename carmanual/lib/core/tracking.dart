class TrackEvent {
  const TrackEvent(this.type, this.message);

  final String type;
  final String message;
}

class Logger {
  Logger(String string);

  void fine(String s) {}

  void finer(String s) {}
}
