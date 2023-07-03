import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';

void main() {
  Firestore.initialize("formshelper-f0d02");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<String>> getFromDB() async {
    await Future.delayed(Duration(seconds: 1));
    var map = await Firestore.instance.collection("questions").get();
    List<String> data = [];
    for (var element in map) {
      print(element.map.keys);
      print(element.map['question']);
      var q = element.map['question'];
      var a = (element.map['answers']).join(', ');
      data.add("$q => $a");
      print("$q => $a");
    }
    //print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getFromDB(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.map((e) => Text(e.toString())).toList(),
            );
          }
          return Text("FUCK");
        },
      ),
    );
  }
}
