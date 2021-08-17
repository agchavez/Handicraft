import 'package:flutter/material.dart';
import 'package:handicraft_app/models/product.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/provider/product_service.dart';
import 'package:handicraft_app/provider/report_service.dart';
import 'package:handicraft_app/provider/storage_service.dart';
import 'package:handicraft_app/provider/user_service.dart';
import 'package:handicraft_app/widgets/productNew.dart';

class SellerPage extends StatefulWidget {
  final String uid;
  const SellerPage({Key key, @required this.uid}) : super(key: key);

  @override
  _SellerPageState createState() => _SellerPageState(uid: this.uid);
}

class _SellerPageState extends State<SellerPage> {
  final String uid;
  _SellerPageState({@required this.uid}) : super();
  Size size;
  String uidUser;
  bool _like = false;
  Map<dynamic, dynamic> userData;
  ReportService reportService = ReportService();
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(body: _createBody());
  }

  Widget _createBody() {
    return SafeArea(
        child: Column(
      children: [
        _createAppbar(),
        _createLikes(),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Text("Productos  ",
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
        _createinformaction(),
      ],
    ));
  }

  Widget _createAppbar() {
    return Container(
      width: size.width * 1,
      padding: EdgeInsets.all(15),
      height: size.height * 0.30,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 23,
                    color: Colors.white,
                  )),
              GestureDetector(
                onTap: () {
                  uidUser == null ? _alert() : _report();
                },
                child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text("Reportar usuario",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.normal))),
              )
            ],
          ),
          FutureBuilder(
              future: AuthService().getUserId(this.uid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  userData = snapshot.data;
                  String name = "${userData["name"]} ${userData["lastname"]}";
                  return Column(
                    children: [
                      Container(
                          width: size.width * 1,
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.1,
                              ),
                              Container(
                                  width: 95.0,
                                  height: 95.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(
                                              userData["photoProfile"])))),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        child: Text(
                                      (name.length > 14)
                                          ? "${name.substring(0, 17)}..."
                                          : name,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Montserrat',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        child: Text(userData["email"],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'Montserrat',
                                                decoration:
                                                    TextDecoration.underline))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(userData["phone"],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Montserrat',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)))
                                  ],
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                              future: UserService().getLikesById(this.uid),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    "${snapshot.data} Seguidores",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return Text(
                                    "0 Seguidores",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  'assets/icons/shop-icon.png',
                                  width: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                userData["Verification"] == 1
                                    ? Image.asset(
                                        'assets/icons/secure-icon.png',
                                        width: 18,
                                      )
                                    : Container()
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  Future<Map<dynamic, dynamic>> getdata() async {
    String uid = await StorageService().getValue("uid");
    if (uid != null) {
      _like = await UserService().verifyLike(this.uid);
    }
    uidUser = uid;

    return {"uid": uid, "megusta": _like};
  }

  _report() {
    int _selectReport;
    bool _report = false, _loadingreport = false, _error = false;
    showDialog(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
              return _report
                  ? _error
                      ? AlertDialog(
                          title: Text("Error al reportar"),
                          content: Text("Ya denunciaste al usuario"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          actions: [
                            MaterialButton(
                                child: Text(
                                  "ok",
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3,
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        )
                      : AlertDialog(
                          title: Text("Gracias por reportar"),
                          content: Text("Se ha enviado el reporte "),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          actions: [
                            MaterialButton(
                                child: Text(
                                  "ok",
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3,
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        )
                  : AlertDialog(
                      title: Text("Denunciar vendedor",
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      content: Container(
                        height: 200,
                        child: FutureBuilder(
                          future: reportService.getReportSeller(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              data = snapshot.data;
                              return Container(
                                height: 180,
                                width: double.maxFinite,
                                child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        _selectReport == data[index]["id"]
                                            ? _selectReport = null
                                            : _selectReport = data[index]["id"];

                                        setState(() {});
                                      },
                                      child: Row(
                                        children: [
                                          _selectReport == data[index]["id"]
                                              ? Icon(Icons.brightness_1_rounded)
                                              : Icon(
                                                  Icons.brightness_1_outlined),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(data[index]["name"],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      actions: [
                        Divider(
                          color: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.black),
                                ),
                                elevation: 3,
                                onPressed: () => Navigator.pop(context)),
                            _loadingreport
                                ? Container(
                                    margin:
                                        EdgeInsets.only(right: 46, left: 20),
                                    child: SizedBox(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                      height: 20.0,
                                      width: 20.0,
                                    ),
                                  )
                                : MaterialButton(
                                    child: Text(
                                      "Reportar",
                                      style: TextStyle(
                                          color: _selectReport == null
                                              ? Colors.grey
                                              : Colors.white),
                                    ),
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    elevation: 3,
                                    onPressed: _selectReport == null
                                        ? null
                                        : () async {
                                            setState(() {
                                              _loadingreport = true;
                                            });

                                            final resp = await reportService
                                                .postReportUser(
                                                    _selectReport, this.uid);
                                            if (resp) {
                                              _error = true;
                                              _report = true;
                                              _loadingreport = false;
                                              setState(() {});
                                            } else {
                                              setState(() {
                                                _error = true;
                                                _loadingreport = false;
                                                setState(() {});
                                              });
                                            }
                                          })
                          ],
                        )
                      ],
                    );
            }));
  }

  _alert() async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Error!"),
              content: Text("Necesita crear una cuenta o iniciar seccion."),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              actions: [
                MaterialButton(
                    child: Text(
                      "Ir a registro",
                      style: TextStyle(color: Colors.black),
                    ),
                    elevation: 3,
                    onPressed: () =>
                        Navigator.popAndPushNamed(context, "register")),
                MaterialButton(
                    child: Text(
                      "ok",
                      style: TextStyle(color: Colors.black),
                    ),
                    elevation: 3,
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  }

  Widget _createLikes() {
    return FutureBuilder(
      future: getdata(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return GestureDetector(
            onTap: () async {
              if (data["uid"] != null) {
                if (!_like) {
                  if (await UserService().addLike(this.uid)) {
                    _like = true;
                  }
                } else {
                  if (await UserService().removeLike(this.uid)) {
                    _like = false;
                  }
                }

                setState(() {});
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 20),
              width: size.width * 0.5,
              height: 55,
              decoration: BoxDecoration(
                  color: data["uid"] == null ? Colors.grey[350] : Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _like
                      ? Image.asset(
                          'assets/icons/liked-icon.png',
                          width: 17,
                        )
                      : Image.asset(
                          'assets/icons/like-icon.png',
                          width: 17,
                        ),
                  //
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    _like ? "Ya no me gusta" : "Me gusta",
                    style: TextStyle(
                        color:
                            data["uid"] == null ? Colors.black : Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _createinformaction() {
    return Expanded(
      child: FutureBuilder(
          future: UserService().getProductsSeller(this.uid),
          builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
            if (snapshot.hasData) {
              //items = snapshot.data;
              data = snapshot.data;
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.9,
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 180,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(bottom: 15),
                      child: ProductNew(
                        product: data[index],
                      ),
                    );
                  });
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
            }
          }),
    );
  }
}
