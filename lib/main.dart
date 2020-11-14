import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/services/firebase_service.dart';
import 'package:task_manager/services/notifications_service.dart';
import 'package:task_manager/services/theme_service.dart';
import 'package:task_manager/stores/store_category.dart';
import 'package:task_manager/stores/task_store.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'models/color_theme_model.dart';
import 'pages/home_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
var firestore = FirebaseFirestore.instance;
var theme;
var providers = [
  Provider<TaskStore>(create: (_) => TaskStore(FirebaseService())),
  Provider<CategoryStore>(create: (_) => CategoryStore())
];

Future<void> main() async {
  await _initializeLocalNotifications();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: providers, child: MyApp()),
  );
}

_initializeLocalNotifications() async {
  NotificationsService notificationsService = NotificationsService();
  notificationsService.initializeLocalNotifications();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  theme = prefs.getString("theme") != null ? prefs.getString("theme") : "green";
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorTheme colorTheme = ColorTheme();
    ThemeService themeService = ThemeService();
    colorTheme =
        themeService.createColorsList().where((c) => c.name == theme).first;
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              primarySwatch: colorTheme.primaryColor,
              accentColor: colorTheme.secondaryColor,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'Task Manager',
            theme: theme,
            home: MyHomePage(FirebaseService()),
          );
        });
  }
}
