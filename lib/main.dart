import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<String> countList = <String>[];

  @override
  void initState() {
    loadCounterValue();
    super.initState();
  }

  void loadCounterValue() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _counter = pref.getInt("counter") ?? 0;
      countList = pref.getStringList("list") ?? [];
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      countList.add(_counter.toString());
      saveCounterValue();
    });
  }

  void saveCounterValue() async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt("counter", _counter);
    pref.setStringList("list", countList);
  }

  void removeData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove("counter");
    await pref.remove("list");
    // after remove reload counter value from Pref.
    loadCounterValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text('$_counter', style: Theme.of(context).textTheme.headline4),
            const Text("Below we are showing list "),
            Text('$countList', style: Theme.of(context).textTheme.headline4),
            OutlinedButton(
                onPressed: () {
                  removeData();
                },
                child: const Text("Reset Counter"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
