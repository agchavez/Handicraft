import 'package:flutter/material.dart';
import 'package:handicraft_app/models/product_stock.dart';
import 'package:handicraft_app/utils/util.dart';

class ProductStockWidget extends StatelessWidget {
  final ProductStock product;
  const ProductStockWidget({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        modal(context, 0.30, [
          {
            "icon": Icon(Icons.reply_all_outlined, color: Colors.black),
            "title": Text("Ir",
                style: TextStyle(fontSize: 14, fontFamily: 'Montserrat')),
            "fnc": _test
          },
          {
            "icon": Icon(Icons.edit_outlined, color: Colors.black),
            "title": Text("Editar producto",
                style: TextStyle(fontSize: 14, fontFamily: 'Montserrat')),
            "fnc": _test
          },
          {
            "icon": Icon(
                this.product.status == 1
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.black),
            "title": Text(
                "${this.product.status == 1 ? "Ocultar" : "Mostrar"} producto",
                style: TextStyle(fontSize: 14, fontFamily: 'Montserrat')),
            "fnc": _test
          },
          {
            "icon": Icon(Icons.delete_outline, color: Colors.red),
            "title": Text("Eliminar producto",
                style: TextStyle(
                    fontSize: 14, fontFamily: 'Montserrat', color: Colors.red)),
            "fnc": _test
          },
        ]);
      },
      child: Container(
        child: Column(
          children: [
            this.product.status == 1
                ? _image(this.product.urlImage, true)
                : _image(this.product.urlImage, false),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 1.0,
                ),
                Text(
                  (this.product.name.length > 19)
                      ? "${this.product.name.substring(0, 17)}..."
                      : this.product.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text(
                  this.product.location,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(
                  height: 3.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price: ${this.product.cost}",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                          color: Colors.grey[500],
                          fontFamily: 'Montserrat'),
                    ),
                  ],
                ),
                this.product.status == 1
                    ? Text("Activo",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.green,
                            fontFamily: 'Montserrat'))
                    : Text("Inactivo",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.red,
                            fontFamily: 'Montserrat'))
              ],
            )
          ],
        ),
      ),
    );
  }

  _test() {}

  Widget _image(String url, bool status) {
    //getHttp();
    return Container(
      height: 130,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(top: 5, right: 5),
        alignment: Alignment.topRight,
        child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 12,
            child: Icon(
              Icons.menu_rounded,
              color: Colors.black,
              size: 20,
            )),
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: !status
                ? ColorFilter.mode(Colors.grey[600], BlendMode.modulate)
                : null,
            image: NetworkImage(
              url,
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
    );
  }
}
