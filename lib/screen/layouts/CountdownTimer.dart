import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gcaeco_app/helper/Config.dart';

class CountdownTimerItem extends StatefulWidget {
    String endTime;
    double fontSize;
   CountdownTimerItem(this.endTime,this.fontSize);

  @override
  _CountdownTimerItemState createState() => _CountdownTimerItemState();
}

class _CountdownTimerItemState extends State<CountdownTimerItem> {
  CountdownTimerController controller;

  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      controller: controller,
      endTime: int.parse(widget.endTime) * 1000,
      widgetBuilder: (_, CurrentRemainingTime time) {
        if (time == null) {
          return Row(
            children: [
              ItemTime("00"),
              SizedBox(width: 3,),
              Text(":",  style: TextStyle(
                  color: Config().colorMain,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize),),
              SizedBox(width: 3,),
              ItemTime("00"),
              SizedBox(width: 3,),
              Text(":", style: TextStyle(
                  color: Config().colorMain,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize),),
              SizedBox(width: 3,),
              ItemTime("00"),
            ],
          );
        }
        return Row(
          children: [
            time.days == null ? Container() : ItemTime(time.days),
            SizedBox(width: 3,),
            time.days == null ? Container() : Text(":",  style: TextStyle(
                color: Config().colorMain,
                fontWeight: FontWeight.bold,
                fontSize: widget.fontSize),),
            SizedBox(width: 3,),
            ItemTime(time.hours),
            SizedBox(width: 3,),
            Text(":",  style: TextStyle(
                color: Config().colorMain,
                fontWeight: FontWeight.bold,
                fontSize: widget.fontSize),),
            SizedBox(width: 3,),
            ItemTime(time.min),
            SizedBox(width: 3,),
            Text(":", style: TextStyle(
                color: Config().colorMain,
                fontWeight: FontWeight.bold,
                fontSize: widget.fontSize),),
            SizedBox(width: 3,),
            ItemTime(time.sec),
          ],
        );
      },
    );
  }

  Widget ItemTime(time) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Center(
          child: Text(
            time == null ? "00" : time.toString(),
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: widget.fontSize),
          )),
      width: 25,
      height: 25,
    );
  }
}
