import 'package:flutter/material.dart';
import 'package:google/constants.dart';
import 'package:google/models/message_model.dart';

class ChatBubble extends StatelessWidget {
const  ChatBubble({super.key,required this.message});
final    MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(message.message , style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
class ChatBubbleForFriend extends StatelessWidget {
const  ChatBubbleForFriend({super.key,required this.message});
final    MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xff006387),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Text(message.message , style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
