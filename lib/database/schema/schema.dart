import 'package:flutter/cupertino.dart';
import 'package:quickeydb/quickeydb.dart';
import '../model/task_manager.dart';


class TaskManagerSchema extends DataAccessObject<TaskManager> {

  final ValueNotifier<bool> _tasksUpdatedNotifier = ValueNotifier(false);

  void notifyTasksUpdated() {
    _tasksUpdatedNotifier.value = !_tasksUpdatedNotifier.value;
  }


  ValueNotifier<bool> get tasksUpdatedNotifier => _tasksUpdatedNotifier;

  TaskManagerSchema()
      : super(
    '''
          CREATE TABLE tasks_manager (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            task_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            status INTEGER,
            priority INTEGER
          )
          ''',

    converter: Converter(
      encode: (task) => TaskManager.fromMap(task),
      decode: (task) => task!.toMap(),
      decodeTable: (task) => task!.toTableMap(),
    ),
  );



  Future<int> insertTask(int taskId, String title, String description, int status, int priority) async {


    Map<String, dynamic> row = {
      'task_id': taskId,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
    };

    int id = await database!.insert('tasks_manager', row);

    return id;
  }

  Future<List<TaskManager>> getAllTasks() async {

    List<Map<String, dynamic>> maps = await database!.query('tasks_manager');

    return List.generate(maps.length, (i) {
      return TaskManager.fromMap(maps[i]);
    });
  }


  Future<List<TaskManager>> searchTasks(String searchTerm) async {

    List<Map<String, dynamic>> maps = await database!.query(
      'tasks_manager',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$searchTerm%', '%$searchTerm%'],
    );

    return List.generate(maps.length, (i) {
      return TaskManager.fromMap(maps[i]);
    });
  }



  Future<List<TaskManager>> filterByCategory(String filterTerm, int num) async {

    List<Map<String, dynamic>> maps = await database!.query(
      'tasks_manager',
      where: '$filterTerm = ?',
      whereArgs: [num],
    );

    return List.generate(maps.length, (i) {
      return TaskManager.fromMap(maps[i]);
    });
  }




  Future<List<TaskManager>> fetchData(String filterTask, int num, String searchTerm) async {
    late List<Map<String, dynamic>> maps;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (filterTask.isNotEmpty) {
      whereClause += '$filterTask = ?';
      whereArgs.add(num);
    }

    if (searchTerm.isNotEmpty) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += '(title LIKE ? OR description LIKE ?)';
      whereArgs.addAll(['%$searchTerm%', '%$searchTerm%']);
    }

    maps = await database!.query(
      'tasks_manager',
      where: whereClause,
      whereArgs: whereArgs,
    );

    return List.generate(maps.length, (i) {
      return TaskManager.fromMap(maps[i]);
    });
  }






}