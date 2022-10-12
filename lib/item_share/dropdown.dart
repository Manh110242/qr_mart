import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  String value;
  String hint;
  List ListValue ;
  String validator;
  Function onChange;
  DropDown({this.ListValue, this.value, this.hint, this.validator,this.onChange});
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: widget.value,
      style: TextStyle(color: Color(0xff8f8b21)),
      decoration: InputDecoration(
        errorText: null,
        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: Color(0xffc4a95a)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Color(0xff8f8b21), width: 3),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xffc4a95a))),
      ),
      hint: Text(
        widget.hint,
        style: TextStyle(color: Color(0xff8f8b21)),
      ),
      onChanged: (value) {
        widget.onChange(value);
      },
      items: widget.ListValue.toSet()
          .map((e) => DropdownMenuItem(
        child: Text(e),
        value: e,
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return widget.validator;
        }
        return null;
      },
    );
  }
}
