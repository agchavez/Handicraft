import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:handicraft_app/models/model_details.dart';
import 'package:handicraft_app/pages/photoHero.dart';
import 'package:handicraft_app/provider/product_service.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

RefreshController _refreshController = RefreshController(initialRefresh: false);

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
    print(idProduct);

    final size = MediaQuery.of(context).size;
    final heightScreen = MediaQuery.of(context).size.height;
    final widthScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: FutureBuilder(
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
                PhotoHero(
                  photo: snapshot.data[0].images[0],
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  width: 400,
                  height: 300,
                ),
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
                            child: Image.asset(
                              'assets/images/porfile.png',
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
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          )),
                        ],
                      ),
                      Container(
                        width: size.height,
                        child: Text(
                          data.description,
                          style: TextStyle(fontSize: 15, color: Colors.white),
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
                      )
                    ])),
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Center(
                      child: Column(
                    children: [
                      Text(
                        'Coments and chat',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )),
                )
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
    );
  }
}
