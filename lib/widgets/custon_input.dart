import 'package:flutter/material.dart';

class CustonInput extends StatelessWidget {
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyBoardtype;
  final bool isError;
  final int maxaling;

  const CustonInput(
      {Key key,
      this.maxaling = 1,
      this.placeholder,
      this.textController,
      this.keyBoardtype = TextInputType.text,
      this.isError = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 16, right: 20),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black)),
      child: TextField(
        cursorColor: Colors.black,
        maxLines: this.maxaling,
        controller: this.textController,
        autocorrect: false,
        keyboardType: this.keyBoardtype,
        decoration: InputDecoration(
            suffixIcon: this.isError
                ? Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  )
                : null,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: this.placeholder),
      ),
    );
  }
}
