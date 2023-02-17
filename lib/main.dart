import 'package:flutter/material.dart';
import 'package:registration_form_1/controllers/User_page.dart';
import 'package:registration_form_1/models/form_data.dart';
//import 'package:registration_form_1/Registration_Form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: UserPage(),
    );
  }
}
