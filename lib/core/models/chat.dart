import 'package:redesigned/core/models/person.dart';

enum LastMessageState {
  sentByUserAndSeen,
  sentByUserAndUnseen,
  sentByOtherandSeen,
  sentByOtherAndUnseen,
}

class Chat {
  Chat({
    required this.person,
    required this.newMessage,
    required this.lastMessage,
    required this.lastTime,
    this.lastMessageState = LastMessageState.sentByOtherandSeen,
    this.isActive = false,
  });
  Person person;
  int newMessage;
  String lastMessage;
  String lastTime;
  bool isActive;
  LastMessageState lastMessageState;
}

class Note {
  Note({required this.person, required this.note});
  Person person;
  String note;
}

class ChatText {
  ChatText({
    required this.text,
    required this.time,
    required this.textid,
    this.reactions = const [],
    this.repliedTo,
    this.sentByUser = false,
  });
  final String text;
  final String time;
  final dynamic repliedTo;
  final int textid;
  List<String> reactions;
  bool sentByUser;
}
