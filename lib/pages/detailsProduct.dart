import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/model_comments.dart';
import 'package:handicraft_app/models/model_details.dart';
import 'package:handicraft_app/pages/photoHero.dart';
import 'package:handicraft_app/pages/seller_page.dart';
import 'package:handicraft_app/provider/product_service.dart';
import 'package:handicraft_app/provider/storage_service.dart';

class ProductsDetail extends StatefulWidget {
  @override
  _ProductsDetailState createState() => _ProductsDetailState();
}

double heightScreen, widthScreen;

int cont = 0;
int idProduct;
ProductInfoModel data;
bool idUser = false;

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
    existUserbool();

    return Scaffold(
        body: SingleChildScrollView(
      child: FutureBuilder(
        future: ProductService().getPostsDetail(idProduct),
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductInfoModel>> snapshot) {
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
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
                                          //color: Colors.amber,
                                          child: Column(
                                        children: [
                                          Text(
                                            (data.name.length > 17)
                                                ? "${data.name.substring(0, 17)}..."
                                                : data.name,
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 19,
                                                color: Colors.white),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SellerPage(uid: data.idUser)),
                                );
                              },
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
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ])),
                SizedBox(
                  height: 15,
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
                SizedBox(
                  height: 15,
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
      print(resp);
    }
  }

  Widget comments(Size size, BuildContext context) {
    return Column(
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
        SizedBox(
          height: 15,
        ),
        _showComments(size, data.comments, context),
        Container(
          height: 20,
        ),
        _comentary(size),
      ],
    );
  }

  Widget _comentary(Size size) {
    if (idUser == true) {
      return Container(
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
              suffixIcon: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0.0, primary: Colors.transparent),
                child: Icon(
                  Icons.send,
                  color: Colors.black,
                ),
                onPressed: () {
                  _addCommentary(myController.text);
                },
              )),
        ),
      );
    } else {
      return Text('');
    }
  }
  /* final MyList<ProductCommentsModel> on List<ProductCommentsModel> {
  List<ProductCommentsModel> sortedBy(Comparable Function(ProductCommentsModel) fn) {
    sort((a, b) => fn(a).compareTo(fn(b)));
    return this;
  }
}*/

  Widget _showComments(
      Size size, List<ProductCommentsModel> data, BuildContext context) {
    if (data.length >= 1) {
      return Flex(
        direction: Axis.vertical,
        children: <Widget>[
          ListBody(
            mainAxis: Axis.vertical,
            children: <Widget>[
              //for (var i = 0; i < data.length; i++)
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
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(data[0].photoProfile)),
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
                                (data[0].name.length > 14)
                                    ? "${data[0].name.substring(0, 14)}..."
                                    : data[0].name,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data[0].date + '   ' + data[0].time,
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
                    data[0].comentary,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ])
            ],
          ),
          GestureDetector(
            onTap: () {
              dynamic arr = [];
              arr.add(data);
              arr.add(idProduct);
              Navigator.pushNamed(context, 'allcomentary', arguments: arr);
            },
            child: textAll(data.length),
          ),
        ],
      );
    } else {
      return Text('');
    }
  }
}

Widget textAll(int len) {
  if (len != 1) {
    return Text(
      'Ver los ' + len.toString() + ' comentarios',
      style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
    );
  } else {
    return Text('');
  }
}

existUserbool() async {
  //idUser = false;
  final user = await StorageService().getValue("uid");

  if (user == null || user == '') {
    idUser = false;
    print('USUSARIO ' + idUser.toString());

    return false;
  } else {
    idUser = true;
    print('USUSARIO ' + idUser.toString());

    return true;
  }
}
