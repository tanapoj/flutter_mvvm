import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(pageIndex: 1),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.pageIndex}) : super(key: key);

  final int pageIndex;

  @override
  _MyHomePageState createState() => _MyHomePageState(this.pageIndex);
}

//================================================================================================

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.idx) {
    print('CON: ${this.idx}');
  }

  @override
  void dispose() {
    super.dispose();
    print('       DISPOSE: ${this.idx}');
  }

  int idx;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _next(BuildContext context) {
    var route = MaterialPageRoute(
      builder: (context) => MyHomePage(
        pageIndex: widget.pageIndex + 1,
      ),
    );
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pageIndex}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'ไทยญี่ปุ่น',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  'engEng',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                )
              ],
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            FloatingActionButton(
              onPressed: () => _next(context),
              tooltip: 'Next',
              child: Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: '$idx',
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
