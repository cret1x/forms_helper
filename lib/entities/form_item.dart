class FormItem {
  final String title;
  final String description;

  FormItem({
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  factory FormItem.fromMap(Map<String, dynamic> json) {
    String title = json['title'] ?? "unnamed";
    String description = json['description'] ?? "";
    return FormItem(title: title, description: description);
  }

  Map<String, dynamic> toGoogleFormJson() {
    return {
      'title': title,
      'description': description,
    };
  }
  factory FormItem.fromGoogleFormJson(Map<String, dynamic> json) {
    String title = json['title'] ?? "unnamed";
    String description = json['description'] ?? "";
    return FormItem(title: title, description: description);
  }

  @override
  bool operator ==(Object other) {
    if (other is FormItem) {
      return title == other.title;
    }
    return false;
  }
}
