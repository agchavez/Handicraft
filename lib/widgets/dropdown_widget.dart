import 'package:flutter/material.dart';
import 'package:handicraft_app/models/location_model.dart';

class DropdownHan extends StatelessWidget {
  List<LocationModel> list = [];
  double width, height, size = 15;
  LocationModel value;
  bool error;
  String hint;
  Function fnOnchage;
  DropdownHan(
      {Key key,
      @required this.hint,
      @required this.value,
      @required this.height,
      @required this.fnOnchage,
      @required this.list,
      this.size,
      this.error = false,
      @required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonFormField<LocationModel>(
        value: this.value,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      width: 2.5,
                      color: Colors.black
                  )
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      width: 2.5,
                      color: Colors.black
                  )
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 100,
                      color: Colors.white10
                  )
              )
          ),
        items: this.list.map((LocationModel location) {
          return new DropdownMenuItem<LocationModel>(
            value: location,
            child: new Text(
              location.name,
              style: new TextStyle(color: Colors.black, fontSize: size),
            ),
          );
        }).toList(),
        onChanged: (value) async {
          this.fnOnchage(value);
        },
        isExpanded: true,
        elevation: 16,
        iconSize: 25,
        hint: Text(this.hint),
        style: TextStyle(color: Colors.black, fontSize: 16),
        icon: Row(
          children: [
            Icon(
              Icons.arrow_drop_down,
              size: 32,
            ),
            this.error
                ? Icon(
              Icons.error_outline_outlined,
              color: Colors.red,
            )
                : Container()
          ],
        ),
        iconEnabledColor: Colors.black,
        validator: (value) {
          if (value == null) {
            return "Campo requerido";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
