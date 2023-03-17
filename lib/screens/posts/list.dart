import 'package:communityapp/models/user.dart';
import 'package:communityapp/screens/posts/item.dart';
import 'package:communityapp/services/posts.dart';
import 'package:communityapp/services/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';





class ListPosts extends StatefulWidget {
  PostModel? post;
  ListPosts(this.post,{Key? key}) : super(key: key);

  @override
  _ListPostsState createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    List<PostModel> posts = Provider.of<List<PostModel>?>(context) ?? [];
    if(widget.post != null)
    {
      posts.insert(0, widget.post as PostModel);
    }

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return StreamBuilder(
            stream: _userService.getUserInfo(post.creator),
            builder:
                (BuildContext context, AsyncSnapshot<UserModel> snapshotUser) {
              if (!snapshotUser.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              //stream builder to get user like
              return StreamBuilder(
                  stream: _postService.getCurrentUserLike(post),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshotLike) {
                    if (!snapshotLike.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ItemPost(post,snapshotUser,snapshotLike);
                  });
            });
      },
    );
  }
}
