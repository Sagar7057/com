import 'dart:ffi';

import 'package:communityapp/models/post.dart';
import 'package:communityapp/screens/posts/list.dart';
import 'package:communityapp/services/posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  FeedState createState() => FeedState();
}

class FeedState extends State<Feed> {
  final PostService _postService = PostService();
  
  @override
  Widget build(BuildContext context) {
    return FutureProvider.value(
      value: _postService.getFeed(),
      initialData:null,
      child: Scaffold(body: ListPosts(null)),
    );
  }
}