import 'package:flutter/material.dart';

import 'themes.dart';
import 'ui/app/app.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun with Flutter',
      theme: AppTheme.theme(),
      // initialRoute: '/', // Render Home page from initial route
      // onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      home: const App(),
    );
  }
}