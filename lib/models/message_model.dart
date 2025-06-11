import 'package:google/constants.dart';

class MessageModel {
   final String message;
   final String id;
   MessageModel(this.message, this.id, );
  factory MessageModel.fromJson(jsonData) {
    return MessageModel(jsonData[kMessage],jsonData[kId]);
  }
}
