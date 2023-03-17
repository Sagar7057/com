


import 'package:communityapp/services/posts.dart';
import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../models/user.dart';





class ItemPost extends StatefulWidget {
  final PostModel post;
  final AsyncSnapshot<UserModel> snapshotUser;
  final AsyncSnapshot<bool> snapshotLike;
  const ItemPost(this.post,this.snapshotUser,this.snapshotLike,{Key? key}) : super(key: key);

  @override
  State<ItemPost> createState() => _ItemPostState();
}

class _ItemPostState extends State<ItemPost> {
  final PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(
          children: [
            widget.snapshotUser.data?.profileImageUrl != ''
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        widget.snapshotUser.data?.profileImageUrl ?? ''))
                : const Icon(Icons.person, size: 40),
            const SizedBox(width: 10),
            Text(widget.snapshotUser.data?.name ?? '')
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.post.text),
                const SizedBox(height: 20),
                Text(widget.post.timestamp.toDate().toString()),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: [
                  Row(children: [
                  IconButton(
                    icon: Icon(
                        widget.snapshotLike.data ?? false
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.blue,
                        size: 30.0),
                    onPressed: () {
                      _postService.likePost(
                          widget.post, widget.snapshotLike.data ?? false);
                    }),
                Text(widget.post.likesCount.toString())
                ],),
                 Row(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.chat_bubble_outline,
                                color: Colors.blue, size: 30.0),
                            onPressed: () => Navigator.pushNamed(
                                context, '/replies',
                                arguments: widget.post)),
                      ],
                    )

                ],)
                
                
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}