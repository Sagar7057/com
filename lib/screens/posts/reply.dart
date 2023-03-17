import 'package:communityapp/models/post.dart';
import 'package:communityapp/screens/posts/list.dart';
import 'package:communityapp/services/posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Replies extends StatefulWidget {
  const Replies({Key? key}) : super(key: key);

  @override
  _RepliesState createState() => _RepliesState();
}

class _RepliesState extends State<Replies> {
  final PostService _postService = PostService();
  String text = '';
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as PostModel;
    return FutureProvider.value(
        value: _postService.getReplies(args),
        initialData: null,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(child: ListPosts(args)),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Form(
                        child: TextFormField(
                      controller: _textController,
                      onChanged: (val) {
                        setState(() {
                          text = val;
                        });
                      },
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      ElevatedButton(onPressed:() =>  Navigator.pushNamed(context, '/',),
                      child:const Text('Back')
                      ),
                      const SizedBox(width:10),
                      ElevatedButton(
                       
                        onPressed: () async {
                          await _postService.reply(args, text);
                          _textController.text = '';
                          setState(() {
                            text = '';
                          });
                          Navigator.pop(context);
                        },
                        child: const Text("Reply"))
                    ],)
                    
                  ],
                ),
              )
            ],
          ),
        ));
  }
}