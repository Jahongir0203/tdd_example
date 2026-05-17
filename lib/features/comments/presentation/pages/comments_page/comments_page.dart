import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: Text(
          'Comments',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ),
      body: Center(child: Text('$this qweqwe')),
    );
  }
}
