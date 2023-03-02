import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/routes.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GTN Info',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(0, 105, 147, 1),
      ),
      initialRoute: GetRoutes.auth,
      getPages: GetRoutes.routes,
    );
  }
}
