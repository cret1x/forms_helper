class Answer {
  final String value;

  Answer({required this.value});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['value'] = value;
    return res;
  }
}