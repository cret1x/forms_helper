class Tag {
  final String id;
  String value;

  Tag({required this.id, required this.value});

  Map<String, dynamic> toMap() {
    return {'id': id, 'value': value};
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(id: map['id'], value: map['value']);
  }
}