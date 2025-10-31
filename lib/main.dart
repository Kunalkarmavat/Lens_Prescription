import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eye_prescription/db/db_helper.dart';
import 'package:eye_prescription/provider/db_provider.dart';
import 'package:eye_prescription/screens/home_screen.dart';

Future<void> main() async {


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DbProvider(dbHelper: DBHelper.getInstance)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
