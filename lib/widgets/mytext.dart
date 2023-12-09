import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masaidizi/base/BaseData.dart';
class MyTextView extends StatefulWidget {
  int maxlines;
  double fontsize;
  Color color;
  FontWeight fontWeight;
  String data;
  MyTextView({required this.data,this.maxlines = 1,this.color = Colors.black,this.fontsize = 14,this.fontWeight = FontWeight.normal,Key? key});
  @override
  State<MyTextView> createState() => _MyTextViewState();
}

class _MyTextViewState extends State<MyTextView> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data,
      maxLines: widget.maxlines,
      style: GoogleFonts.oswald(
        color: widget.color,
        fontWeight: widget.fontWeight,
        fontSize: widget.fontsize,

      ),
    );
  }
}

//richtext
class MyFormatedText extends StatefulWidget {
  String original,sub,fontfamily;
  double fontsize;
  Color colors;
  FontWeight fontWeight;
  MyFormatedText(this.original,this.sub,this.fontfamily,this.colors,this.fontWeight,this.fontsize,{Key? key}) : super(key: key);

  @override
  State<MyFormatedText> createState() => _MyFormatedTextState();
}

class _MyFormatedTextState extends State<MyFormatedText> {
  BaseData baseData = BaseData();
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
          text: widget.original,
          style: TextStyle(
            fontWeight: widget.fontWeight,
            fontFamily: widget.fontfamily,
            color:baseData.basecolor,
            fontSize: widget.fontsize+15
          ),
          children: <TextSpan>[
           TextSpan(
             text: widget.sub,
             style: TextStyle(
               fontWeight: widget.fontWeight,
               fontFamily: widget.fontfamily,
               color: widget.colors,
               fontSize: widget.fontsize
             ),
           )
        ]
      )
    );
  }
}

class MySelectableText extends StatefulWidget {
  int maxlines;
  double fontsize;
  Color color;
  FontWeight fontWeight;
  String data;
  MySelectableText({required this.data,this.maxlines = 1,this.color = Colors.black,this.fontsize = 14,this.fontWeight = FontWeight.normal,Key? key});

  @override
  State<MySelectableText> createState() => _MySelectableTextState();
}

class _MySelectableTextState extends State<MySelectableText> {
  @override
  Widget build(BuildContext context) {
    return SelectableText(widget.data,
      maxLines: widget.maxlines,
      style: GoogleFonts.oswald(
        color: widget.color,
        fontWeight: widget.fontWeight,
        fontSize: widget.fontsize,

      ),);
  }
}

