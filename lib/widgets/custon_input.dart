import 'package:flutter/material.dart';

class CustonInput extends StatelessWidget {
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyBoardtype;
  final bool isError;
  final int maxaling;
  final int maxLengthDescription;

  const CustonInput(
      {Key key,
      this.maxaling = 1,
      this.placeholder,
      this.textController,
      this.keyBoardtype = TextInputType.text,
      this.isError = false,
      this.maxLengthDescription
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Colors.black,
        style: TextStyle(decorationColor: Colors.transparent),
        maxLines: this.maxaling,
        controller: this.textController,
        autocorrect: false,
        keyboardType: this.keyBoardtype,
        maxLength: maxLengthDescription != null ? maxLengthDescription : null,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              )
            ),
            suffixIcon: this.isError
                ? Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  )
                : null,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              )
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 100, color: Colors.white10),
              borderRadius: BorderRadius.circular(10.0)
            ),
            hintText: this.placeholder),
      ),
    );
  }
}
