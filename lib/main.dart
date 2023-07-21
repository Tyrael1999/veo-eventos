import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veo_eventos/pages/calendar.dart';
import 'package:veo_eventos/pages/home.dart';
import 'package:veo_eventos/pages/create_event.dart';
import 'package:veo_eventos/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();
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

  Widget getPage() {
    switch (selectedIndex) {
      case 0:
        return CalendarPage();
      case 1:
        return HomePage();
      case 2:
        return CreateEventPage();
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Visibility(
        visible: selectedIndex == 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 60, 20, 60),
          child: FloatingActionButton(
            shape: CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            onPressed: () {
              onButtonPressed(2);
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text('VEO Eventos')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: getPage(),
              ),
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
                    onPressed: () => {},
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
