import 'package:communityapp/services/posts.dart';
import 'package:flutter/material.dart';


class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddState();
  }
}

class _AddState extends State<Add> {
  final PostService _postService = PostService();
  String text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tweet'),
          actions: <Widget>[
            ElevatedButton(
                style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 15),),
                onPressed: () async {
                  _postService.savePost(text);
                  Navigator.pop(context);
                },
                child: const Text('Tweet'))
          ],
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Form(child: TextFormField(
              onChanged: (val) {
                setState(() {
                  text = val;
                });
              },
            ))));
  }
}