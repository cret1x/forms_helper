import 'package:flutter/material.dart';
import 'package:forms_helper/screens/side_menu.dart';

import '../common/themes.dart';

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _HomeState extends State<HomeWidget> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.darkBlue,
      home: Scaffold(
        body: Row(
          children: [
            MenuWidget(_controller),
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  Container(color: Colors.red,),
                  Container(color: Colors.blue,),
                  Container(color: Colors.yellow,),
                  Container(color: Colors.green,),
                  Container(color: Colors.orange,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
}