class TrackEvent {
  const TrackEvent(this.type, this.message);

  final String type;
  final String message;
}

class Logger {
  static void log(String s) {
    print("Logging: $s");
  }
}
