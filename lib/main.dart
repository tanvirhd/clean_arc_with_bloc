
import 'package:clean_arc_bloc/app/main_app.dart';
import 'package:clean_arc_bloc/core/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //init sharedPref
  await SharedPreferenceHelper().init();

  runApp(MainApp());
}

