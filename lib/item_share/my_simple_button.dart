import 'package:flutter/material.dart';
import 'package:gcaeco_app/validators/app_constants.dart';

class MySimpleButton extends StatefulWidget {
  final Color buttoncolor;
  final Color buttontextcolor;
  final Color shadowcolor;
  final String buttontext;
  final double width;
  final double height;
  final double spacing;
  final double borderradius;
  final Function onpressed;

  MySimpleButton(
      {this.buttontext,
        this.buttoncolor,
        this.height,
        this.spacing,
        this.borderradius,
        this.width,
        this.buttontextcolor,
        this.onpressed,
        this.shadowcolor});
  @override
  _MySimpleButtonState createState() => _MySimpleButtonState();
}

class _MySimpleButtonState extends State<MySimpleButton> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: widget.onpressed as void Function(),
        child: Container(
          alignment: Alignment.center,
          width: widget.width ?? w - 40,
          height: widget.height ?? 50,
          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Text(
            widget.buttontext ?? 'Submit',
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: widget.spacing ?? 2,
              fontSize: 15,
              color: widget.buttontextcolor ?? Colors.white,
            ),
          ),
          decoration: BoxDecoration(
              color: widget.buttoncolor ?? Colors.primaries as Color,
              //gradient: LinearGradient(colors: [bgColor, whiteColor]),
              boxShadow: [
                BoxShadow(
                    color: widget.shadowcolor ?? Colors.transparent,
                    blurRadius: 10,
                    spreadRadius: 2)
              ],
              border: Border.all(
                color: widget.buttoncolor ?? fiberchatgreen,
              ),
              borderRadius:
              BorderRadius.all(Radius.circular(widget.borderradius ?? 5))),
        ));
  }
}
