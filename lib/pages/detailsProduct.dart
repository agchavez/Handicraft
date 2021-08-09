import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/model_comments.dart';
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
  final myController = TextEditingController();

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    myController.dispose();
    super.dispose();
  }

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
        bottomSheet: Container(
          padding: EdgeInsets.fromLTRB(30, 10, 6, 8),
          height: size.height * 0.059,
          width: size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: TextFormField(
            controller: myController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.grey[600]),
            decoration: InputDecoration(
                hintText: 'Escribe un comentario...',
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                suffixIcon: RaisedButton(
                  elevation: 0.0,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.send,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _addCommentary(myController.text);
                  },
                )),
          ),
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
                        ),
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  comments(size, context),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          },
        )));
  }

//agregar comentarios
  _addCommentary(String data) async {
    if (data != '') {
      setState(() {});
      myController.clear();
      final body = {
        "comentary": data,
      };
      final resp = await ProductService().addComentary(body, idProduct);
    }
  }

  Widget comments(Size size, BuildContext context) {
    return SingleChildScrollView(
        child: Column(
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
        _showComments(size, data.comments, context),
        Container(
          height: 80,
        )
      ],
    ));
  }

  Widget _showComments(
      Size size, List<Product_Comments_Model> data, BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        ListBody(
          mainAxis: Axis.vertical,
          children: <Widget>[
            for (var i = 0; i < data.length; i++)
              Column(children: [
                Container(
                    padding: EdgeInsets.fromLTRB(10, 3, 6, 10),
                    height: size.height * 0.057,
                    width: size.height * 0.44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Image.network(
                              data[i].photoProfile,
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
                                data[i].name,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data[i].date + '   ' + data[i].time,
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
                  child: Text(data[i].comentary),
                ),
              ])
          ],
        )
      ],
    );
  }
}
