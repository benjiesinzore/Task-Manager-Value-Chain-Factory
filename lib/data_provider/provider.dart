import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../database/model/task_manager.dart';
import '../database/schema/schema.dart';



class TaskProvider with ChangeNotifier {
  List<TaskManager> _data = [];

  String exception = "";

  List<TaskManager> get retData => _data;

  String _selectedFilter = stringAll;

  String get selectedFilter => _selectedFilter;

  Future<void> updateData(List<TaskManager> newData) async {
    _data = newData;
    notifyListeners();
  }


  //GET ALL TASKS - METHOD
  Future<void> getTask() async {
    try {
      List<TaskManager> data = await TaskManagerSchema().getAllTasks();
      updateData(data);

    } catch (error) {
      exception = error.toString();
    }
  }


  //GET-UPDATES - METHOD
  Future<List<TaskManager>> getUpdate() async {

    if (exception.isEmpty){
      return retData;
    } else {
      throw Exception(exception);
    }

  }

  //FETCH TASK - METHOD :: THE DIFFERENCE WITH SEARCH IS THAT THIS ACCEPTS MORE PARAMETERS
  Future<void> fetchTask(String filterTask, int num, String searchTerm) async {
    try {

      List<TaskManager> data = await TaskManagerSchema().fetchData(
          filterTask,
          num,
          searchTerm
      );
      updateData(data);

    } catch (error) {
      exception = error.toString();
    }
  }

  //SEARCH FOR TASK - METHOD
  Future<void> searchTask(String searchTerm) async {
    try {

      List<TaskManager> data = await TaskManagerSchema().searchTasks(
          searchTerm
      );
      updateData(data);

    } catch (error) {
      exception = error.toString();
    }
  }


  //UPDATE SPECIFIC TASK  - METHOD
  void updateSelectedFilter(String option) {
    _selectedFilter = option;
    notifyListeners();
  }

  String getSelectedFilter(){
    return selectedFilter;
  }


  //INSERT NEW TASK - METHOD
  Future<int> insertTask(title, description, status, priority) async {


    try {

        int id = await TaskManagerSchema().insertTask(47, title, description, status, priority);
        getTask();
        return id;

    } catch (error) {
      exception = error.toString();
      return 0;
    }


  }


  //UPDATE TASK - METHOD
  Future<void> updateTask(taskId, title, description, status, priority) async {

    try {

      TaskManager task = TaskManager(
        id: taskId,
        title: title,
        description: description,
        status: status,
        priority: priority,
      );
      await TaskManagerSchema().update(task);

      getTask();

    } catch (error) {
      exception = error.toString();
    }

  }



  //DELETE TASK - METHOD
  Future<void> deleteTask(TaskManager task) async {

    try {

      await TaskManagerSchema().delete(task);
      getTask();

    } catch (error) {
      exception = error.toString();
    }
  }



}

