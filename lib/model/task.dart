class Task {
  String title;
  String description;
  DateTime dateTime;
  bool isComplete;

  Task({
    required this.title,
    required this.description,
    required this.dateTime,
    this.isComplete = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'dateTime': dateTime.toIso8601String(),
    'isComplete': isComplete,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    description: json['description'] ?? '',
    dateTime: DateTime.parse(json['dateTime']),
    isComplete: json['isComplete'] ?? false,
  );
}
