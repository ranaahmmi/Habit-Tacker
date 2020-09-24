import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prefecthabittracer/models/user.dart';
import 'package:provider/provider.dart';
import 'chatMessage.dart';
import 'package:prefecthabittracer/style/theme.dart' as ColorTheme;
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textEditingController =
      new TextEditingController(); //To manage interactions with textfield

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('UserData')
                      .document(user.uid)
                      .collection('Chats')
                      .orderBy('event_date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final doc = snapshot.data.documents;
                      return ListView.builder(
                        padding: EdgeInsets.all(10),
                        reverse: true,
                        itemBuilder: (context, i) {
                          return ChatMessage(
                            name: doc[i]['name'],
                            text: doc[i]['message'],
                            date: doc[i]['event_date'],
                          );
                        },
                        itemCount: doc.length,
                      );
                    }
                    return 'please wait...'.text.xl3.center.makeCentered();
                  }),
            ),

            //---------------Message Input box with send button
            Divider(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(user.uid),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer(String uid) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: TextField(
              controller:
                  _textEditingController, //clear field or read its value
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              color: ColorTheme.Colors.loginGradientEnd,
              onPressed: () {
                _textEditingController.text == ''
                    ? null
                    : _handleSubmitted(_textEditingController.text, uid);
              }),
        ],
      ),
    );
  }

  void _handleSubmitted(String text, String uid) async {
    await Firestore.instance
        .collection('UserData')
        .document(uid)
        .collection('Chats')
        .add({"name": 'user', "message": text, "event_date": DateTime.now()});

    _textEditingController.clear();
    setState(() {});
  }
}
