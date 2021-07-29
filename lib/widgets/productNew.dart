import 'package:flutter/material.dart';
import 'package:handicraft_app/models/product.dart';

class ProductNew extends StatelessWidget {
  final Product_Model product;
  const ProductNew({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(this.product.name.length);
    return Container(
      height: size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 3.0,
              ),
              Text(
                this.product.location,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              ),
              SizedBox(
                height: 3.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.product.cost,
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _image(String url) {
    //getHttp();
    return ClipRRect(
      child: Image.network(
        url,
        height: 135,
        width: 155,
      ),
      borderRadius: BorderRadius.circular(15),
    );
  }
}
