import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/model_Product_Infor.dart';
import 'package:handicraft_app/models/model_comments.dart';
import 'package:handicraft_app/models/model_details.dart';
import 'package:handicraft_app/provider/product_service.dart';
import 'package:handicraft_app/provider/storage_service.dart';
import 'package:http/http.dart' as http;

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
bool focus;

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
    focus = data0[2];

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
      Size size, List<ProductCommentsModel> dataC, BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        FutureBuilder(
            future: ProductService().getComentary(idProduct),
            builder: (BuildContext context,
                AsyncSnapshot<List<ProductCommentsModel>> snapshot) {
              if (snapshot.hasError) {
              } else if (snapshot.hasData) {
                //final data2 = snapshot.data;
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: _information(snapshot.data[index], size),
                      );
                      print(snapshot.data[index]);
                      return //Padding(
                          //padding: const EdgeInsets.only(left: 20, right: 20),
                          Container(
                        child: _information(snapshot.data[index], size),
                      );
                      // );
                    });
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }),
        SizedBox(
          height: 100,
        )
      ],
    );
  }

  Widget _information(ProductCommentsModel dataComentary, Size size) {
    print('ksjdajksdnsa');
    return Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(10, 3, 6, 10),
          height: size.height * 0.057,
          width: size.height * 0.44,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              width: 50,
              height: size.height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(dataComentary.photoProfile)),
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
                  (dataComentary.name.length > 14)
                      ? "${dataComentary.name.substring(0, 14)}..."
                      : dataComentary.name,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  dataComentary.date + '   ' + dataComentary.time,
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
        //constraints: BoxConstraints.expand(),
        padding: EdgeInsets.fromLTRB(20, 3, 6, 10),
        width: size.width * 0.65,

        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          dataComentary.comentary,
          style: TextStyle(
            fontFamily: 'Montserrat',
          ),
          maxLines: null,
          textAlign: TextAlign.start,
        ),
      ),
    ]);
  }

  _addCommentary(String dataController) async {
    if (dataController != '') {
      myController.clear();
      final body = {
        "comentary": dataController,
      };

      final resp = await ProductService().addComentary(body, idProduct);
      final response = await http.get(Uri.parse(
          "https://hechoencasa-backend.herokuapp.com/product/getInfo/${idProduct}"));
      //print(response.body);
      data = productInforModelFromJson(response.body).data.comments;

      setState(() {
        // myMetodo(); //data = await ProductService().getPostsDetail(idProduct);
        print(data);
      });
      //Navigator.pop(context);

      print(resp);
    }
  }

  myMetodo() async {
    data = await ProductService().getComentary(idProduct);
    print('entro' + data.toString());
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
          constraints: BoxConstraints(maxHeight: 100),
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
            expands: true,
            controller: myController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(color: Colors.grey[600]),
            autofocus: focus,
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
          ));
    } else {
      return Text('');
    }
  }
}
