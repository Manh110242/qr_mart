import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';

class CustomDropButtom extends StatelessWidget {
  String title;
  String value;
  String error;
  String hint;
  List list;
  Function onChanged;
  CustomDropButtom(
      {this.title,
      this.value,
      this.hint,
      this.list,
      this.onChanged,
      this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Config.green, fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          DropdownButtonFormField(
              value: value,
              style: TextStyle(color: Config.green),
              decoration: InputDecoration(
                errorText: null,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Config.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Config.green, width: 3),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Config.green)),
              ),
              hint: Text(
                hint,
                style: TextStyle(color: Config.green),
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
              }),
        ],
      ),
    );
  }
}
