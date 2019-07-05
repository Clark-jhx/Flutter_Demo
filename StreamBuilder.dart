import 'dart:async';
import 'package:flutter/material.dart';

void main(){
  runApp(new MaterialApp(
    title: 'StreamBuilder',
    home: new CounterPage(),
  ));
}

class CounterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CounterPageState();
  }
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  final StreamController _streamController = StreamController<int>();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('StreamBuilder'),
      ),
      body: StreamBuilder<int>(
        stream: _streamController.stream,
        initialData: _counter,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return Text('hit me ${snapshot.data} times');
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _streamController.sink.add(++_counter);
        },
      ),
    );
  }
}
