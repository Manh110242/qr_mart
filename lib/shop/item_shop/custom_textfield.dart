import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String title;
  TextEditingController sc;
  String error;
  Function onTap;
  bool showCursor;
  bool readOnly;

  CustomTextField({this.title,this.error,this.sc, this.onTap, this.showCursor,this.readOnly});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
            TextStyle(color: Color(0xff8f8b21), fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: sc,
            showCursor: showCursor != null ? showCursor : false,
            readOnly: readOnly != null ? readOnly : false,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              errorText: null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffc4a95a)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xff8f8b21), width: 3),
              ),
              border: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color(0xffc4a95a))),
            ),
            onTap: onTap,
            validator: (value) {
              if (value.isEmpty) {
                return error;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
