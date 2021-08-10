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
        bottomSheet: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 10, 5),
          padding: EdgeInsets.only(left: 20),
          height: size.height * 0.059,
          width: size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.grey[100],
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
                  color: Colors.transparent,
                  child: Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _addCommentary(myController.text);
                  },
                )),
          ),
        ),
        body: SafeArea(
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
                        height: size.height * 0.20,
                        width: size.height * 0.47,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              data.profilePicture)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                    ),
                                    alignment: Alignment.topCenter,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      //color: Colors.amber,
                                      child: Text(
                                        data.name,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ],
                              ),
                              IconButton(
                                  onPressed: () async {},
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data.email,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
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
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ])),
                    SizedBox(
                      height: 5,
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
                    Expanded(child: comments(size, context)),
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
          padding: EdgeInsets.fromLTRB(10, 10, 6, 10),
          height: size.height * 0.052,
          width: size.height * 0.44,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Text('Comentarios',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold)),
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
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(data[i].photoProfile)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
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
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data[i].date + '   ' + data[i].time,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
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
                  child: Text(
                    data[i].comentary,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ])
          ],
        )
      ],
    );
  }
}
