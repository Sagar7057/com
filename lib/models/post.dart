import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostModel {
  final String id;
  final String creator;
  final String text;
  final Timestamp timestamp;
  DocumentReference ref ;

  int likesCount=0;
  int retweetsCount=0;

  PostModel({required this.id,
  required this.creator,
  required this.text,
  required this.timestamp,
  required this.likesCount,
  required this.ref,
  
  });
}