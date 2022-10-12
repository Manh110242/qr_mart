import 'package:flutter/material.dart';

class CustomDropButtom extends StatelessWidget {
  String title;
  String value;
  String error;
  String hint;
  List list;
  Function onChanged;
  CustomDropButtom({this.title,this.value,this.hint,this.list,this.onChanged,this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Color(0xff8f8b21), fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          DropdownButtonFormField(
            value: value,
            style: TextStyle(color: Color(0xff8f8b21)),
            decoration: InputDecoration(
              errorText: null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffc4a95a)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff8f8b21), width: 3),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffc4a95a))),
            ),
            hint: Text(
              hint,
              style: TextStyle(color: Color(0xff8f8b21)),
            ),
            onChanged: onChanged,
            items: list
                .map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ))
                .toList(),
              validator: (value) {
                if (value == null) {
                  return error;
                }
                return null;
              }
          ),
        ],
      ),
    );
  }
}
