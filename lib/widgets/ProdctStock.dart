import 'package:flutter/material.dart';
import 'package:handicraft_app/models/product.dart';
import 'package:handicraft_app/models/product_stock.dart';

class ProductStockWidget extends StatelessWidget {
  final ProductStock product;
  const ProductStockWidget({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          this.product.status == 1
              ? _image(this.product.urlImage, true)
              : _image(this.product.urlImage, false),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              Text(
                this.product.name,
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
    );
  }

  Widget _image(String url, bool status) {
    //getHttp();
    return Container(
      height: 130,
      alignment: Alignment.centerLeft,
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