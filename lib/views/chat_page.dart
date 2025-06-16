import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google/constants.dart';
import 'package:google/cubits/chat_cubit/chat_cubit.dart';
import 'package:google/models/message_model.dart';
import 'package:google/widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  static String id = "ChatPage";

  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    List<MessageModel> messageslist = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Image.asset(klogo, height: 60),
            Text("Chat", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                List<MessageModel> messageslist = BlocProvider.of<ChatCubit>(context).messageslist;
                return ListView.builder(
                  reverse: true,
                  controller: scrollController,
                  itemCount: messageslist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return messageslist[index].id == email
                        ? ChatBubble(message: messageslist[index])
                        : ChatBubbleForFriend(message: messageslist[index]);
                  },
                );
              },
        
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              onSubmitted: (message) {
                if (message.isNotEmpty) {
                  BlocProvider.of<ChatCubit>(
                    context,
                  ).sendMessage(message: message, email: email);
                  controller.clear();
                  scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                }
              },
              maxLines: null,
              textInputAction: TextInputAction.send,
              // keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Send Massege",
                suffixIcon: GestureDetector(
                  // onTap: sendMessage,
                  child: Icon(Icons.send),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
    
  

  // void sendMessage() {
  //   final value = controller.text.trim();
  //   if (value.isNotEmpty) {
  //     messages.add({kMessage: value, kCreatedAt: DateTime.now(), 'id': email});
  //     controller.clear();
  //     scrollController.animateTo(
  //       0,
  //       duration: Duration(milliseconds: 500),
  //       curve: Curves.easeIn,
  //     );
  //   }
  // }

