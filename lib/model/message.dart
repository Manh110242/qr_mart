import 'package:flutter/material.dart';
import 'package:gcaeco_app/provider/seen_provider.dart';

class Message {
  Message(Widget child,
      {@required this.timestamp,
        @required this.from,
        @required this.onTap,
        @required this.onDoubleTap,
        @required this.onDismiss,
        @required this.onLongPress,
        this.saved = false})
      : child = wrapMessage(
      child: child as SeenProvider,
      onDismiss: onDismiss,
      onDoubleTap: onDoubleTap,
      onTap: onTap,
      onLongPress: onLongPress,
      saved: saved);

  final String from;
  final Widget child;
  final int timestamp;
  final VoidCallback onTap, onDoubleTap, onDismiss, onLongPress;
  final bool saved;
  static Widget wrapMessage(
      {@required SeenProvider child,
        @required onDismiss,
        @required onDoubleTap,
        @required onTap,
        @required onLongPress,
        @required bool saved}) {
    return child.child.isMe
        ? GestureDetector(
      child: child,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
    )
        : GestureDetector(
      child: child,
      onDoubleTap: onDoubleTap,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
