import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google/constants.dart';
import 'package:google/models/message_model.dart';
import 'package:google/widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  static String id = "ChatPage";
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollections,
  );
  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messageslist = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageslist.add(MessageModel.fromJson(snapshot.data!.docs[i]));
          }
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
                  child: ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    itemCount: messageslist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return messageslist[index].id == email
                          ? ChatBubble(message: messageslist[index])
                          : ChatBubbleForFriend(message: messageslist[index]);
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        messages.add({
                          kMessage: value,
                          kCreatedAt: DateTime.now(),
                          'id': email,
                        });
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
        } else {
          return Text("loding");
        }
      },
    );
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
}
