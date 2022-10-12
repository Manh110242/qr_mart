import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';

class ChatRoomScreen extends StatefulWidget {
  final String peerNo, currentUserNo;

  final int unread;

  const ChatRoomScreen({
    Key key,
    this.currentUserNo,
    this.peerNo,
    this.unread,
  }) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.peerNo),
            ],
          ),
        ),
      ),
    );
  }
}
