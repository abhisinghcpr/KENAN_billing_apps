import 'package:flutter/material.dart';
import 'package:flutter_tasks/view/screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'controller/bill_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BillProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bills App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
