import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/model_details.dart';
import 'package:handicraft_app/pages/photoHero.dart';
import 'package:handicraft_app/provider/product_service.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductsDetail extends StatefulWidget {
  @override
  _ProductsDetailState createState() => _ProductsDetailState();
}

double heightScreen, widthScreen;

int cont = 0;
int idProduct;
Product_Info_Model data;

class _ProductsDetailState extends State<ProductsDetail> {
  //List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    idProduct = ModalRoute.of(context).settings.arguments;

    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: ProductService().getPostsDetail(idProduct),
            builder: (BuildContext context,
                AsyncSnapshot<List<Product_Info_Model>> snapshot) {
              if (snapshot.hasError) {
              } else if (snapshot.hasData) {
                data = snapshot.data[0];
                //items = snapshot.data;
                return Column(
                  // The blue background emphasizes that it's a new route.

                  children: [
                    carousel(data.images),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(30, 10, 6, 10),
                        height: size.height * 0.17,
                        width: size.height * 0.47,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Image.network(
                                  data.profilePicture,
                                  height: 50,
                                ),
                                alignment: Alignment.topCenter,
                              ),
                              Container(
                                width: 20,
                              ),
                              Container(
                                  //color: Colors.amber,
                                  child: Column(
                                children: [
                                  Text(
                                    data.name,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  Text(
                                    data.email,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              )),
                            ],
                          ),
                          Container(
                            width: size.height,
                            child: Text(
                              data.description,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: size.height,
                            child: Text(
                              data.cost,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ])),
                    SizedBox(
                      height: 5,
                    ),
                    comments(size),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            },
          ),
        ));
  }
}

Widget comments(Size size) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(30, 10, 6, 8),
        height: size.height * 0.052,
        width: size.height * 0.44,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: TextFormField(
          keyboardType: TextInputType.text,
          initialValue: 'Hola, sigue disponible?',
          style: TextStyle(color: Colors.grey[600]),
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            suffixIcon: Image.asset(
              'assets/icons/chat2.png',
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(10, 10, 6, 10),
        height: size.height * 0.052,
        width: size.height * 0.44,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text('Comentarios',
            style: TextStyle(
                color: Colors.grey[400], fontWeight: FontWeight.bold)),
      ),
      Container(
          padding: EdgeInsets.fromLTRB(10, 3, 6, 10),
          height: size.height * 0.057,
          width: size.height * 0.44,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: Image.asset(
                'assets/images/porfile.png',
                height: 70,
              ),
              alignment: Alignment.topCenter,
            ),
            Container(
              width: 8,
            ),
            Container(
                child: Column(
              children: [
                Text(
                  'Daniela Zavala',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '03 de feb 2021 2:00 pm',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            )),
          ])),
      Container(
        padding: EdgeInsets.fromLTRB(10, 3, 6, 10),
        height: size.height * 0.050,
        width: size.height * 0.44,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text('Hola, sigue disponible?'),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(30, 10, 6, 8),
        height: size.height * 0.052,
        width: size.height * 0.44,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: TextFormField(
          keyboardType: TextInputType.text,
          initialValue: 'Escribe un comentario...',
          style: TextStyle(color: Colors.grey[600]),
          decoration: InputDecoration(
              focusedBorder: InputBorder.none, enabledBorder: InputBorder.none),
        ),
      ),
    ],
  );
}
