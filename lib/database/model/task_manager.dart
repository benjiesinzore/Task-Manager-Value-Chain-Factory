

class TaskManagerData {
  final List<TaskManager> taskManagers;
  final String message;

  TaskManagerData(this.taskManagers, this.message);
}


class TaskManager {
  int? id;
  String title;
  String description;
  int status;
  int priority;


  TaskManager({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
  });

  TaskManager.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        status = map['status'],
        priority = map['priority'];

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
  };

  Map<String, dynamic> toTableMap() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
  };

}