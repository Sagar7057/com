import 'dart:collection';
import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communityapp/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post.dart';
import 'package:quiver/iterables.dart';

class PostService {
  List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostModel(
        id: doc.id,
        text: doc['text'],
        creator: doc['creator'],
        timestamp: doc['timestamp'],
        likesCount: doc['likescount'] ?? 0,
        ref: doc.reference ,
      );
    }).toList();
  }

 

  

    PostModel? _postFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.exists
        ? PostModel(
            id: snapshot.id,
            text: snapshot['text'],
            creator: snapshot['creator'],
            timestamp: snapshot['timestamp'],
            likesCount: snapshot['likescount'] ?? 0,
            ref: snapshot.reference,
          )
        : null;
  }

  Future savePost(text) async {
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Future likePost(PostModel post, bool current) async {
    Map<String, int> data = HashMap();
    data['likescount'] = post.likesCount-1;
    if (current) {
      post.likesCount = post.likesCount - 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();
    }
    if (!current) {
      post.likesCount = post.likesCount + 1;

      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({});
    }
    data['likescount'] = post.likesCount;
 
  await FirebaseFirestore.instance.
          collection("posts").doc(post.id).update(data);

  }

   Stream<bool> getCurrentUserLike(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

Stream<List<PostModel>> getPostsByUser(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Future<PostModel?> getPostById(String id) async {
    DocumentSnapshot postSnap =
        await FirebaseFirestore.instance.collection("posts").doc(id).get();

    return _postFromSnapshot(postSnap);
  }


 Future reply(PostModel post, String text) async {
    if (text == '') {
      return;
    }
    await post.ref.collection("replies").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'likescount':0,
    });
  }

   Future<List<PostModel>> getReplies(PostModel post) async {
    print(post.ref);
    QuerySnapshot querySnapshot = await post.ref
        .collection("replies")
        .orderBy('timestamp', descending: true)
        .get();

    return _postListFromSnapshot(querySnapshot);
  }

  

  // Future<List<PostModel>> getFeed() async {
  //   List<String> usersFollowing = await UserService()
  //                   .getUserFollowing(FirebaseAuth.instance.currentUser?.uid);

  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //                   .collection('posts')
  //                   .where('creator',whereIn: usersFollowing)
  //                   .orderBy('timestamp',descending: true)
  //                   .get();

  //   dynamic ab = _postListFromSnapshot(querySnapshot);

  //   for (dynamic i in ab){ print(i.text);};

  //       return _postListFromSnapshot(querySnapshot);
  // }

   Future<List<PostModel>> getFeed() async {
    List<String> usersFollowing = await UserService() //['uid1', 'uid2']
        .getUserFollowing(FirebaseAuth.instance.currentUser?.uid);

    var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);
    inspect(splitUsersFollowing);

    List<PostModel> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      inspect(splitUsersFollowing.elementAt(i));
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('creator', whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timestamp', descending: true)
          .get();

      feedList.addAll(_postListFromSnapshot(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timestamp;
      var bdate = b.timestamp;
      return bdate.compareTo(adate);
    });

    return feedList;
  }
}


