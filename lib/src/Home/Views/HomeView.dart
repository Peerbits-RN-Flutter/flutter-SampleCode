import 'package:Common/common/ApiFactory/Modules/AuthenticationAPI.dart';
import 'package:Common/common/Utils/Utils.dart';
import 'package:Common/common/Widgets/PBButton.dart';
import 'package:Common/common/Widgets/PBTextInput.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Common/src/Home/Views/DetailsView.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            PBButton(
              onPress: () {
                Get.to(() => DetailsView());
              },
              child: Text(
                "Press",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.apply(color: Colors.white),
              ),
              elevation: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: PBTextInput(
                controller: TextEditingController(),
                isSimpleField: false,
                labelText: "Enter Name",
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
