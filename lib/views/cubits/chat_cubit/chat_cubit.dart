import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google/constants.dart';
import 'package:google/models/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollections,
  );
  List<MessageModel> messageslist = [];

  void sendMessage({required String message, required String email}) {
    try { 
      messages.add({
        kMessage: message,
        kCreatedAt: DateTime.now(),
        'id': email,
      });
    } on Exception catch (e) {}
  }

  void getChat() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messageslist.clear();
      for (var doc in event.docs) {
        messageslist.add(MessageModel.fromJson(doc));
      }
      emit(ChatSuccess(messageslist: messageslist));
    });
  }
}
