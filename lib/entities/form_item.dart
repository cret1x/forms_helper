class FormItem {
  String id;
  final String title;
  final String description;

  FormItem({
    required this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory FormItem.fromMap(Map<String, dynamic> json) {
    String id = json['id'] ?? '';
    String title = json['title'] ?? "unnamed";
    String description = json['description'] ?? "";
    return FormItem(id: id, title: title, description: description);
  }

  Map<String, dynamic> toGoogleFormJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
  factory FormItem.fromGoogleFormJson(Map<String, dynamic> json) {
    String id = json['id'] ?? '';
    String title = json['title'] ?? "unnamed";
    String description = json['description'] ?? "";
    return FormItem(id: id, title: title, description: description);
  }

  @override
  bool operator ==(Object other) {
    if (other is FormItem) {
      return id == other.id;
    }
    return false;
  }
}
