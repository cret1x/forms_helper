import 'package:uuid/uuid.dart';

class Tag {
  String? id;
  String value;
  final Uuid _uuid = const Uuid();

  Tag({this.id, required this.value}) {
    id ??= _uuid.v1();
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'value': value};
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(id: map['id'], value: map['value']);
  }
}