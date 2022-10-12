import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';

class TextField2 extends StatelessWidget {
  String title;
  TextEditingController sc;
  String error;
  Function onTap;
  bool showCursor;
  bool readOnly;
  bool enabled;

  TextField2(
      {this.title,
      this.error,
      this.sc,
      this.onTap,
      this.showCursor,
      this.readOnly,
      this.enabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Config().colorMain, fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 40,
            child: TextFormField(
              controller: sc,
              enabled: enabled,
              showCursor: showCursor != null ? showCursor : false,
              readOnly: readOnly != null ? readOnly : false,
              style: TextStyle(fontSize: 16),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixIcon: Image.asset(
                  "assets/images/percentage-discount.png",
                  color: Config().colorMain,
                ),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                errorText: null,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Config().colorMain)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Config().colorMain)),
              ),
              onTap: onTap,
              validator: (value) {
                if (value.isEmpty) {
                  return error;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
