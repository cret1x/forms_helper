class Answer {
  final String value;

  Answer({required this.value});

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  @override
  bool operator ==(Object other) {
    if (other is Answer) {
      return value == other.value;
    }
    return false;
  }
}