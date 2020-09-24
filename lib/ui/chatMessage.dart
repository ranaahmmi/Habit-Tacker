import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final Timestamp date;
  final String name;

  ChatMessage({this.text, this.date, this.name});

  @override
  Widget build(BuildContext context) {
    return BubbleNormal(
      text: text,
      isSender: name == 'user' ? true : false,
      color: name == 'user' ? Color(0xAF6AD0F5) : Color(0xAF52FF8C),
      tail: true,
    );
  }
}
