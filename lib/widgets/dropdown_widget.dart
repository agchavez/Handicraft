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
      padding: EdgeInsets.only(bottom: 0, left: 16, right: 10),
      height: height,
      width: this.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black)),
      child: Container(
        child: DropdownButton<LocationModel>(
          value: this.value,
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
        ),
      ),
    );
  }
}
