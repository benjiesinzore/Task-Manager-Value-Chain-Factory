import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../data_provider/provider.dart';
import '../database/model/task_manager.dart';
import '../widgets/shared_widgets.dart';

class AddTaskPage extends StatefulWidget {
  final TaskManager? task;
  final String updateOrNewTask;

  const AddTaskPage({super.key, this.task, required this.updateOrNewTask});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  bool pending = true;
  bool complete = false;
  bool high = false;
  bool medium = true;
  int taskId = 0;
  String appBarTitle = "";

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();

    if (widget.updateOrNewTask == stringUpdate && widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;

      pending = widget.task!.status == 0;
      complete = widget.task!.status == 1;
      medium = widget.task!.priority == 0;
      high = widget.task!.priority == 1;

      taskId = widget.task!.id!;

      appBarTitle = "new";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: tdBGColor,
        title: Text(
          // textAddTask,
          widget.updateOrNewTask == "new" ? "Add Task" : "Update Task",
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: inputFieldHintTitle,
                  contentPadding: const EdgeInsets.only(left: 20.0),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: inputFieldHintDescription,
                  contentPadding: const EdgeInsets.only(top: 20.0, bottom: 30.0, left: 20.0),
                ),
                maxLines: 5,
                minLines: 2,
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  textTaskStatus,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text(textPending),
                value: pending,
                onChanged: (bool value) {
                  setState(() {
                    pending = value;
                    complete = !value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(textComplete),
                value: complete,
                onChanged: (bool value) {
                  setState(() {
                    complete = value;
                    pending = !value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  textTaskPriority,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text(textMedium),
                value: medium,
                onChanged: (bool value) {
                  setState(() {
                    medium = value;
                    high = !value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text(textHigh),
                value: high,
                onChanged: (bool value) {
                  setState(() {
                    high = value;
                    medium = !value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          String title = titleController.text;
          String description = descriptionController.text;

          int status = complete ? 1 : 0;
          int priority = high ? 1 : 0;

          if (widget.updateOrNewTask == stringUpdate) {

            Provider.of<TaskProvider>(context, listen: false).updateTask(
                taskId, title, description,
                status, priority
            );

            SharedWidgets().showPopup(context, updateDialogTitle, dialogDescription, taskId, stringUpdateTask);

          } else {


            int id = await Provider.of<TaskProvider>(context, listen: false).insertTask(
                title, description,
                status, priority
            );

            SharedWidgets().showPopup(context, insertDialogTitle, dialogDescription, id, stringAddTask);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }


}
