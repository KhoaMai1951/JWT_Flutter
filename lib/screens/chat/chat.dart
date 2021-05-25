import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_test_2/constants/color_constant.dart';
import 'package:flutter_login_test_2/constants/container_decoration.dart';
import 'package:flutter_login_test_2/constants/text_field.dart';
import 'package:flutter_login_test_2/constants/text_style.dart';
import 'package:flutter_login_test_2/globals/user_global.dart';
import 'package:flutter_login_test_2/models/user_model.dart';
import 'package:flutter_login_test_2/network_utils/api.dart';

final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen_test';
  UserModel userToChat;
  ChatScreen({Key key, this.userToChat}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  String messageText;
  bool firstMessageHasBeenSent =
      false; //đã gửi tin nhắn đầu khi vào màn hình chat

  @override
  void initState() {
    super.initState();
  }

  createRecordForBothUsers() async {
    if (firstMessageHasBeenSent == false) {
      var data = {
        'chat_id': generateChatId(userToChatId: widget.userToChat.id),
        'current_user_id': UserGlobal.user['id'],
        'user_to_chat_with_id': widget.userToChat.id,
      };
      var res = await Network().postData(data, '/chat/create');
      var body = json.decode(res.body);
      print(body);
      setState(() {
        firstMessageHasBeenSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[],
        title: Row(
          children: [
            //AVATAR
            Container(
              margin: EdgeInsets.only(right: 10.0),
              alignment: Alignment.center,
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90.0),
                    image: DecorationImage(
                        image: (widget.userToChat.avatarUrl != '')
                            ? NetworkImage(widget.userToChat.avatarUrl)
                            : AssetImage('images/no-avatar.png'),
                        fit: BoxFit.cover)),
              ),
            ),
            Text(widget.userToChat.username),
          ],
        ),
        backgroundColor: kAppBarColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // MESSAGE STREAM
            MessagesStream(
              chatId: generateChatId(userToChatId: widget.userToChat.id),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      createRecordForBothUsers();
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': UserGlobal.user['email'],
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                        'chat_id':
                            generateChatId(userToChatId: widget.userToChat.id),
                      });
                    },
                    child: Text(
                      'Gửi',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  MessagesStream({this.chatId});
  String chatId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .where('chat_id', whereIn: [chatId])
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        //final messages = snapshot.data.docs.reversed;
        final messages = snapshot.data.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final currentUser = UserGlobal.user['email'];

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            //color: isMe ? Colors.lightBlueAccent : Colors.white,
            color: isMe ? Colors.green : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

generateChatId({int userToChatId}) {
  return userToChatId < UserGlobal.user['id']
      ? userToChatId.toString() + '-' + UserGlobal.user['id'].toString()
      : UserGlobal.user['id'].toString() + '-' + userToChatId.toString();
}
