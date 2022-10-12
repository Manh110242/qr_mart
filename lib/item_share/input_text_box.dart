import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/validators/app_constants.dart';

class InputTextBox extends StatefulWidget {
  final Color boxbcgcolor;
  final Color boxbordercolor;
  final double boxcornerradius;
  final double fontsize;
  final double boxwidth;
  final double boxborderwidth;
  final double boxheight;
  final EdgeInsets forcedmargin;
  final double letterspacing;
  final double leftrightmargin;
  final TextEditingController controller;
  final Function(String val) validator;
  final Function(String val) onSaved;
  final Function(String val) onchanged;
  final TextInputType keyboardtype;
  final TextCapitalization textCapitalization;

  final String title;
  final String subtitle;
  final String hinttext;
  final String placeholder;
  final int maxLines;
  final int minLines;
  final int maxcharacters;
  final bool isboldinput;
  final bool obscuretext;
  final bool autovalidate;
  final bool disabled;
  final bool showIconboundary;
  final Widget sufficIconbutton;
  final List<TextInputFormatter> inputFormatter;
  final Widget prefixIconbutton;

  InputTextBox(
      {this.controller,
        this.boxbordercolor,
        this.boxheight,
        this.fontsize,
        this.leftrightmargin,
        this.letterspacing,
        this.forcedmargin,
        this.boxwidth,
        this.boxcornerradius,
        this.boxbcgcolor,
        this.hinttext,
        this.boxborderwidth,
        this.onSaved,
        this.textCapitalization,
        this.onchanged,
        this.placeholder,
        this.showIconboundary,
        this.subtitle,
        this.disabled,
        this.keyboardtype,
        this.inputFormatter,
        this.validator,
        this.title,
        this.maxLines,
        this.autovalidate,
        this.prefixIconbutton,
        this.maxcharacters,
        this.isboldinput,
        this.obscuretext,
        this.sufficIconbutton,
        this.minLines});
  @override
  _InpuTextBoxState createState() => _InpuTextBoxState();
}

class _InpuTextBoxState extends State<InputTextBox> {
  bool isobscuretext = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isobscuretext = widget.obscuretext ?? false;
    });
  }

  changeobscure() {
    setState(() {
      isobscuretext = !isobscuretext;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Align(
      child: Container(
        margin: EdgeInsets.fromLTRB(
            widget.leftrightmargin ?? 8, 5, widget.leftrightmargin ?? 8, 5),
        width: widget.boxwidth ?? w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // color: Colors.white,
              height: widget.boxheight ?? 50,
              // decoration: BoxDecoration(
              //     color: widget.boxbcgcolor ?? Colors.white,
              //     border: Border.all(
              //         color:
              //             widget.boxbordercolor ?? Mycolors.grey.withOpacity(0.2),
              //         style: BorderStyle.solid,
              //         width: 1.8),
              //     borderRadius: BorderRadius.all(
              //         Radius.circular(widget.boxcornerradius ?? 5))),
              child: TextFormField(
                minLines: widget.minLines ?? null,
                maxLines: widget.maxLines ?? 1,
                controller: widget.controller ?? null,
                obscureText: isobscuretext,
                onSaved: widget.onSaved ?? (val) {},
                readOnly: widget.disabled ?? false,
                onChanged: widget.onchanged ?? (val) {},
                maxLength: widget.maxcharacters ?? null,
                validator:
                widget.validator as String Function(String) ?? null,
                keyboardType: widget.keyboardtype ?? null,
                autovalidateMode: widget.autovalidate == true
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                inputFormatters: widget.inputFormatter ?? [],
                textCapitalization:
                widget.textCapitalization ?? TextCapitalization.sentences,
                style: TextStyle(
                  letterSpacing: widget.letterspacing ?? null,
                  fontSize: widget.fontsize ?? 15,
                  fontWeight: widget.isboldinput == true
                      ? FontWeight.w600
                      : FontWeight.w400,
                  // fontFamily:
                  //     widget.isboldinput == true ? 'NotoBold' : 'NotoRegular',
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    prefixIcon: widget.prefixIconbutton != null
                        ? Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                width: widget.boxborderwidth ?? 1.5,
                                color: widget.showIconboundary == true ||
                                    widget.showIconboundary == null
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.transparent),
                          ),
                          // color: Colors.white,
                        ),
                        margin: EdgeInsets.only(
                            left: 2, right: 5, top: 2, bottom: 2),
                        // height: 45,
                        alignment: Alignment.center,
                        width: 50,
                        child: widget.prefixIconbutton != null
                            ? widget.prefixIconbutton
                            : null)
                        : null,
                    suffixIcon: widget.sufficIconbutton != null ||
                        widget.obscuretext == true
                        ? Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: widget.boxborderwidth ?? 1.5,
                                color: widget.showIconboundary == true ||
                                    widget.showIconboundary == null
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.transparent),
                          ),
                          // color: Colors.white,
                        ),
                        margin: EdgeInsets.only(
                            left: 2, right: 5, top: 2, bottom: 2),
                        // height: 45,
                        alignment: Alignment.center,
                        width: 50,
                        child: widget.sufficIconbutton != null
                            ? widget.sufficIconbutton
                            : widget.obscuretext == true
                            ? IconButton(
                            icon: Icon(
                                isobscuretext == true
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.blueGrey),
                            onPressed: () {
                              changeobscure();
                            })
                            : null)
                        : null,
                    filled: true,
                    fillColor: widget.boxbcgcolor ?? Colors.white,
                    enabledBorder: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderRadius:
                      BorderRadius.circular(widget.boxcornerradius ?? 1),
                      borderSide: BorderSide(
                          color: widget.boxbordercolor ??
                              Colors.grey.withOpacity(0.2),
                          width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderRadius:
                      BorderRadius.circular(widget.boxcornerradius ?? 1),
                      borderSide: BorderSide(color: fiberchatgreen, width: 1.5),
                    ),
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(widget.boxcornerradius ?? 1),
                        borderSide: BorderSide(color: Colors.grey)),
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    // labelText: 'Password',
                    hintText: widget.hinttext ?? '',
                    // fillColor: widget.boxbcgcolor ?? Colors.white,

                    hintStyle: TextStyle(
                        letterSpacing: widget.letterspacing ?? 1.5,
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
