import 'package:flutter/material.dart';
import 'package:handicraft_app/models/location_model.dart';
import 'package:handicraft_app/models/product.dart';

import 'package:handicraft_app/provider/product_service.dart';
import 'package:handicraft_app/provider/storage_service.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/provider/user_service.dart';
import 'package:handicraft_app/utils/util.dart';
import 'package:handicraft_app/widgets/ProdctStock.dart';
import 'package:handicraft_app/widgets/productNew.dart';
import 'package:provider/provider.dart';

class PorfilePage extends StatefulWidget {
  @override
  _PorfilePageState createState() => _PorfilePageState();
}

class _PorfilePageState extends State<PorfilePage> {
  @override
  Size size;
  String uid;
  Map<String, String> userData;
  List<String> categoriesSuscribe = [];
  int _selectedIndex = 0;
  ProductService productService;
  AuthService _authService;

  @override
  void initState() {
    super.initState();

    productService = Provider.of<ProductService>(context, listen: false);
    _authService = Provider.of<AuthService>(context, listen: false);
    init();
  }

  void init() async {
    List<dynamic> resp = await productService.getCategoriesSuscribe();
    for (var item in resp) {
      categoriesSuscribe.add(item.toString());
    }
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(body: _createBody());
  }

  void _test() {
    print("object");
  }

  void signOut() async {
    if (await AuthService().signOut()) {
      Navigator.popAndPushNamed(context, "home");
    }
  }

  Widget _createBody() {
    return SafeArea(
        child: Column(
      children: [
        _createAppbar(),
        _createNavbar(),
        _createinformaction(),
        SizedBox(
          height: 60,
        )
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: MaterialButton(
                  height: 5,
                  minWidth: 5,
                  elevation: 0.0,
                  onPressed: () async {
                    modal(context, 0.25, [
                      {
                        "icon":
                            Icon(Icons.settings_outlined, color: Colors.black),
                        "title": Text("Configuracion",
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'Montserrat')),
                        "fnc": _test
                      },
                      {
                        "icon": Icon(Icons.edit_outlined, color: Colors.black),
                        "title": Text("Editar perfil",
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'Montserrat')),
                        "fnc": _test
                      },
                      {
                        "icon": Icon(
                          Icons.logout_outlined,
                          color: Colors.red,
                        ),
                        "title": Text("Cerar sesion",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                color: Colors.red)),
                        "fnc": signOut
                      }
                    ]);
                  },
                  child: Image.asset(
                    'assets/icons/menu-icon.png',
                    width: 3,
                  ),
                ),
              )
            ],
          ),
          FutureBuilder(
            future: StorageService().getall(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                userData = snapshot.data;
                return Container(
                    width: size.width * 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.1,
                        ),
                        Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 95.0,
                            height: 95.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(
                                        userData["photoProfile"])))),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  child: Text(
                                (userData["displayName"].length > 14)
                                    ? "${userData["displayName"].substring(0, 17)}..."
                                    : userData["displayName"],
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
                                  child: Text(
                                      (userData["email"].length > 17)
                                          ? "${userData["email"].substring(0, 18)}..."
                                          : userData["email"],
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
                    ));
              } else {
                return CircularProgressIndicator(
                  color: Colors.transparent,
                );
              }
            },
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/like-icon.png',
                      width: 17,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FutureBuilder(
                      future: UserService().getLikesById("uid"),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                  ],
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
                    FutureBuilder(
                      future: StorageService().getValue("verified"),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data == 1
                              ? Image.asset(
                                  'assets/icons/secure-icon.png',
                                  width: 18,
                                )
                              : Container();
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createLikes() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: size.width * 0.4,
      height: 55,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/like-icon.png',
            width: 17,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "75 Likes",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

//Navbar
  Widget _createNavbar() {
    return Container(
      height: 60,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          MaterialButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            child: Text(
              "Mis productos",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: _selectedIndex == 0 ? Colors.black : Colors.grey[500],
                  fontWeight: _selectedIndex == 0
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
            child: Text(
              "Stock",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: _selectedIndex == 1 ? Colors.black : Colors.grey[500],
                  fontWeight: _selectedIndex == 1
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
            child: Text(
              "Categorias suscritas",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: _selectedIndex == 2 ? Colors.black : Colors.grey[500],
                  fontWeight: _selectedIndex == 2
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createinformaction() {
    switch (_selectedIndex) {
      case 0:
        return Expanded(
          child: FutureBuilder(
              future: productService.getProductsofUser(),
              builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
                if (snapshot.hasData) {
                  //items = snapshot.data;
                  data = snapshot.data;
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.85,
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
        break;
      case 2:
        return FutureBuilder(
          future: productService.getCategories(),
          builder: (context, AsyncSnapshot<List<LocationModel>> snapshot) {
            if (snapshot.hasData) {
              List<LocationModel> data = snapshot.data;
              return Container(
                padding: EdgeInsets.all(5),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: data
                      .map((item) => GestureDetector(
                            onTap: () async {
                              if (categoriesSuscribe.contains(item.name)) {
                                if (await productService
                                    .removeSuscribeCategorie(item.id)) {
                                  categoriesSuscribe.remove(item.name);
                                }
                              } else {
                                if (await productService
                                    .suscribeCategorie(item.id)) {
                                  categoriesSuscribe.add(item.name);
                                }
                              }
                              setState(() {});
                            },
                            child: Container(
                                height: 40,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color:
                                        categoriesSuscribe.contains(item.name)
                                            ? Colors.black
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: Text(
                                  item.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:
                                          categoriesSuscribe.contains(item.name)
                                              ? Colors.white
                                              : Colors.black,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold),
                                )),
                          ))
                      .toList()
                      .cast<Widget>(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("No tienes categorias"));
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
          },
        );
        break;
      case 1:
        return Expanded(
          child: FutureBuilder(
              future: productService.getHistoryProductUser(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  //items = snapshot.data;
                  data = snapshot.data;
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.85,
                        crossAxisCount: 2,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 180,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.only(bottom: 15),
                          child: ProductStockWidget(
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
        break;
      default:
        return Container();
    }
  }
}
