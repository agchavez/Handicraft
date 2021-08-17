import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/model_comments.dart';
import 'package:handicraft_app/provider/product_service.dart';
import 'package:handicraft_app/provider/storage_service.dart';

class AllComments extends StatefulWidget {
  @override
  _AllCommentsState createState() => _AllCommentsState();
}

double heightScreen, widthScreen;

int cont = 0;
List<ProductCommentsModel> data;
bool idUser = false;
int idProduct;
dynamic data0;

class _AllCommentsState extends State<AllComments> {
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
    data0 = ModalRoute.of(context).settings.arguments;
    data = data0[0];
    idProduct = data0[1];

    final size = MediaQuery.of(context).size;
    existUserbool();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          title: Text('Comentarios')),
      body: SingleChildScrollView(child: _showComentary(size, data, context)),
      floatingActionButton: _comentary(size),
    );
  }

  Widget _showComentary(
      Size size, List<ProductCommentsModel> data, BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
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
                            width: 50,
                            height: size.height,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(data[i].photoProfile)),
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
                                (data[i].name.length > 14)
                                    ? "${data[i].name.substring(0, 14)}..."
                                    : data[i].name,
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
        ),
        SizedBox(
          height: 100,
        )
      ],
    );
  }

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

  Widget _comentary(Size size) {
    if (idUser == true) {
      return Container(
        alignment:
            AlignmentGeometry.lerp(Alignment.center, Alignment.center, 1.0),
        margin: EdgeInsets.fromLTRB(20, 0, 10, 5),
        padding: EdgeInsets.only(left: 20),
        height: size.height * 0.059,
        width: size.height * 0.45,
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
}
