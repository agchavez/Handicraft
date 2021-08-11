import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:handicraft_app/models/product.dart';
import 'package:handicraft_app/provider/product_service.dart';

class ProductsPages extends StatefulWidget {
  @override
  _ProductsPgaesState createState() => _ProductsPgaesState();
}

double heightScreen, widthScreen;

int cont = 0;

class _ProductsPgaesState extends State<ProductsPages> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 22),
              child:
                  Image.asset('assets/icons/search-black-icon.png', width: 20),
            ),
          ],
          title:
              Image(width: 140, image: AssetImage('assets/images/logo.png'))),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
            child: Row(
              children: [
                Text(
                  "Productos",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                      fontSize: 18),
                )
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: ProductService().getPosts(cont),
            builder: (BuildContext context,
                AsyncSnapshot<List<ProductModel>> snapshot) {
              if (snapshot.hasError) {
              } else if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.78),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 10, bottom: 20),
                        child: Container(
                          child: _information(snapshot.data[index]),
                        ),
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            },
          ))
        ],
      ),
    );
  }

  Widget _information(ProductModel data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            _image(data.urlImage, context, data),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.0, left: 5.0),
              child: Text(
                (data.name.length > 14)
                    ? "${data.name.substring(0, 14)}..."
                    : data.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    fontFamily: 'Montserrat'),
              ),
            )
          ],
        ),
        SizedBox(
          height: 3.0,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                data.location,
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                'Precio: ${data.cost}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  color: Color(0xFFC4C4C4),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _image(String url, BuildContext context, ProductModel data) {
    timeDilation = 0.8;

    //getHttp();
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, 'details', arguments: data.idProduct);
        },
        child: Container(
          height: size.height * 0.2,
          width: size.width * 0.40,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  url,
                ),
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
        ));
  }
}
