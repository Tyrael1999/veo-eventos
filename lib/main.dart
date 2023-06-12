import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/pages/calendar.dart';
import 'package:namer_app/pages/home.dart';
import 'package:namer_app/pages/settings.dart';
import 'package:namer_app/app_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'VEO Eventos',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget getPage(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return CalendarPage();
      case 1:
        return HomePage();
      case 2:
        return SettingsPage();
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text('VEO Eventos')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: getPage(context),
            ),
          ),
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => onButtonPressed(0),
                    child: Icon(Icons.calendar_month),
                  ),
                  ElevatedButton(
                    onPressed: () => onButtonPressed(1),
                    child: Icon(Icons.home),
                  ),
                  ElevatedButton(
                    onPressed: () => onButtonPressed(2),
                    child: Icon(Icons.settings),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
