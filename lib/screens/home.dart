import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:value8/database/model/task_manager.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../data_provider/provider.dart';
import '../widgets/shared_widgets.dart';
import 'add_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> filterParams = [];


  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: tdBGColor,
      appBar: buildAppBar(screenSize),
      body: Padding(

        padding: const EdgeInsets.all(10.0),
        child: Consumer<TaskProvider>(

          builder: (context, cart, child) {

            return Column(
              children: [
                FutureBuilder(
                  future: cart.getUpdate(),
                  builder: (context, AsyncSnapshot<List<TaskManager>> snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                     else if (snapshot.hasError) {
                      String errorMessage = snapshot.error.toString();
                      int exceptionIndex = errorMessage.indexOf(':');
                      if (exceptionIndex != -1) {
                        errorMessage = errorMessage.substring(exceptionIndex + 2);
                      }
                      return Center(child: Text('Error: $errorMessage'));
                    }

                    else if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text(stringNoTask));
                      } else {

                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AddTaskPage(task: snapshot.data![index], updateOrNewTask: "update")),
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(snapshot.data![index].title),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data![index].description),
                                        Text(
                                          'Status: ${snapshot.data![index].status == 0 ? stringPending : stringComplete}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Priority: ${snapshot.data![index].status == 0 ? stringMedium : stringHigh}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () {
                                            _scaffoldKey.currentState!.openDrawer();
                                          },
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: const Icon(Icons.edit, size: 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        showPopup(context, snapshot.data![index]);
                                      },
                                      child: const Icon(Icons.delete),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );

                      }
                    }
                    return const Text('');
                  },
                ),
              ],
            );
          },
        ),
      ),

      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const SizedBox(
                height: 150.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      textTaskManager,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  ListTile(
                    title: const Text(
                      textAddTask,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddTaskPage(updateOrNewTask: "new")),
                      );
                    },
                  ),
                  const Divider(),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }


  Future<void> showPopup(BuildContext context, TaskManager task) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        var screenWidth = MediaQuery.of(context).size.width;

        var dialogWidth = screenWidth;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizedBox(
            width: dialogWidth,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(textDeleteTask, style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 10),
                  const Text(
                      stringConfirmDeleteText,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text(textProceed),
                        onPressed: () {

                          Provider.of<TaskProvider>(context, listen: false).deleteTask(task);
                          Navigator.of(context).pop();
                          SharedWidgets().showPopup(context, deleteDialogTitle, dialogDescription, task.id!, "delete_task");
                        },
                      ),
                      TextButton(
                        child: const Text(textCancel),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  AppBar buildAppBar(Size screenSize) {

    double toolbarHeight = screenSize.height < 800 ? 200 : screenSize.height * 0.3;

    double buttonSize = screenSize.width > 600 ? 45 : 40;

    double iconSize = buttonSize * 0.8;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: tdBGColor,
      elevation: 0,
      toolbarHeight: toolbarHeight,
      title: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            child: SizedBox(
              height: buttonSize,
              width: buttonSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Icon(Icons.menu, size: iconSize),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {

            },
            child: SizedBox(
              height: iconSize,
              width: iconSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/logo_icon.jpeg'),
              ),
            ),
          ),
        ]),

        const SizedBox(height: 5),

        const Text(
          textTaskManager,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 15),

        searchBox(),

        const SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [


          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),

            child:
            Consumer<TaskProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getSelectedFilter().toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                );
              },
            )

          ),

          GestureDetector(
            onTapDown: (TapDownDetails details) {


              final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset overlayTopLeft = overlay.localToGlobal(Offset.zero);
              final Offset tapPosition = details.globalPosition;
              final Offset menuPosition = Offset(
                tapPosition.dx - overlayTopLeft.dx,
                tapPosition.dy - overlayTopLeft.dy + 40,
              );

              displayMenu(menuPosition);

            },
            child: SizedBox(
              height: buttonSize,
              width: buttonSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Icon(Icons.filter_list, size: iconSize,),
              ),
            ),
          ),
        ])

      ]),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => runFilterSearch(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: hintSearch,
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  void runFilterSearch(String value) {

    if (value.isNotEmpty) {
      if (filterParams.isEmpty) {
        Provider.of<TaskProvider>(context, listen: false).searchTask(value);
      } else {
        Provider.of<TaskProvider>(context, listen: false).fetchTask(
            filterParams[0] as String,
            filterParams[1] as int,
            value
        );
      }
    }

  }

  displayMenu(Offset menuPosition) {

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(menuPosition.dx, menuPosition.dy, 0, 0),
      items: [
        const PopupMenuItem(
          value: stringAll,
          child: Text(allTask),
        ),
        const PopupMenuItem(
          value: textComplete,
          child: Text(completeTask),
        ),
        const PopupMenuItem(
          value: textPending,
          child: Text(pendingTask),
        ),
        const PopupMenuItem(
          value: textHigh,
          child: Text(highPriorityTask),
        ),
        const PopupMenuItem(
          value: textMedium,
          child: Text(mediumPriorityTask),
        ),
      ],
      elevation: 8.0,
    ).then((value) {

      if (value != null) {

        Provider.of<TaskProvider>(context, listen: false).updateSelectedFilter(value);


        final Map<String, List<dynamic>> filterMap = {
          "Complete": ["status", 1],
          "Pending": ["status", 0],
          "High": ["priority", 1],
          "Medium": ["priority", 0],
          "All": [],
        };

        filterParams = filterMap[value]!;

        if(value == stringAll){
          Provider.of<TaskProvider>(context, listen: false).getTask();
        } else {
          Provider.of<TaskProvider>(context, listen: false).fetchTask(
              filterParams[0] as String,
              filterParams[1] as int,
              ""
          );
        }

      }
    });
  }


}

