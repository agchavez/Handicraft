import 'package:flutter/material.dart';
import 'package:handicraft_app/models/product.dart';

class ProductNew extends StatelessWidget {
  final ProductModel product;
  const ProductNew({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _image(this.product.urlImage),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.0,
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
              Text("Nuevo",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      color: Colors.grey[400],
                      fontFamily: 'Montserrat')),
            ],
          )
        ],
      ),
    );
  }

  Widget _image(String url) {
    //getHttp();
    return Container(
      height: 130,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              url,
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
    );
  }
}
