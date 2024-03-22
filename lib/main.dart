import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickeydb/quickeydb.dart';
import 'package:value8/screens/home.dart';
import 'package:value8/screens/splash.dart';
import 'constants/strings.dart';
import 'data_provider/provider.dart';
import 'database/schema/schema.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const MyApp());
}


Future<void> initializeDatabase() async {
  await QuickeyDB.initialize(
    persist: false,
    dbVersion: 1,
    dataAccessObjects: [
      TaskManagerSchema(),
    ],
    dbName: databaseName,
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

      future: initializeDatabase(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: SplashScreen(),
          );
        } else {

          return ChangeNotifierProvider(
            create: (_) => TaskProvider(),
            child: Builder(builder: (BuildContext context) {

              Provider.of<TaskProvider>(context, listen: false).getTask();

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: textTaskManager,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: const HomeScreen(),
              );
            }),
          );
        }
      },
    );
  }
}

