import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/**
 * 参考文章地址
 * https://blog.csdn.net/yumi0629/article/details/82759447
 */

void main() {
  runApp(new MaterialApp(
    title: 'StreamBuilder and Bloc',
    home: BlocProvider<IncrementBloc>(
        child: CounterPage(),
        bloc: IncrementBloc()),
  ));
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final IncrementBloc bloc = BlocProvider.of<IncrementBloc>(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('streamBuilder and Bloc'),
      ),
      body: new Center(
        child: StreamBuilder(
          stream: bloc._stream,
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Text('hit me: ${snapshot.data} times');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc._actionStream.add(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

abstract class BlocBase {
  void dispose();
}

class IncrementBloc implements BlocBase {
  int _counter;

  // 通知UI的stream
  StreamController<int> _streamController = StreamController<int>();
  StreamSink<int> get _sink => _streamController.sink;
  Stream<int> get _stream => _streamController.stream;

  // 处理业务逻辑的stream
  StreamController _actionStreamController = StreamController();
  StreamSink get _actionStream => _actionStreamController.sink;

  // 构造器
  IncrementBloc() {
    _counter = 0;
    _actionStreamController.stream.listen(_handleLogic);
  }

  void _handleLogic(data) {
    _counter = _counter + 1;
    _sink.add(_counter);
  }

  @override
  void dispose() {
    _streamController.close();
    _actionStreamController.close();
  }
}

// 通用 BLoC provider
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
