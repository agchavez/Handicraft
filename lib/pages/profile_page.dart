import 'package:flutter/material.dart';
import 'package:handicraft_app/models/location_model.dart';
import 'package:handicraft_app/models/product.dart';
import 'package:handicraft_app/provider/product_service.dart';
import 'package:handicraft_app/provider/storage_service.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/widgets/productNew.dart';
import 'package:provider/provider.dart';

class PorfilePage extends StatefulWidget {
  @override
  _PorfilePageState createState() => _PorfilePageState();
}

class _PorfilePageState extends State<PorfilePage> {
  @override
  Size size;
  final List<String> categoriesSuscribe = [
    "Ropa y Calzado",
    "Joyeria y Complementos"
  ];
  int _selectedIndex = 0;
  ProductService productService;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    productService = Provider.of<ProductService>(context, listen: false);
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(body: _createBody());
  }

  Widget _createBody() {
    return SafeArea(
        child: Expanded(
      child: Column(
        children: [
          _createAppbar(),
          Visibility(
            child: _createLikes(),
            visible: _selectedIndex == 0,
          ),
          SizedBox(
            height: 20,
          ),
          _createNavbar(),
          _createinformaction(),
          SizedBox(
            height: 60,
          )
        ],
      ),
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.white,
                  )),
              Container(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/icons/menu-icon.png',
                  width: 3,
                ),
              )
            ],
          ),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 0.1,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 37,
                child: Text(
                  "AC",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 150,
                      child: Text(
                        "Angel Chavez",
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
                      width: 150,
                      child: Text("agchavez@unah.hn",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline))),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: 150,
                      child: Text("9993773",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))
                ],
              )
            ],
          )),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/icons/shop-icon.png',
                  width: 18,
                ),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  'assets/icons/secure-icon.png',
                  width: 18,
                ),
              ],
            ),
          )
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

  Widget _createNavbar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            child: Text(
              "Productos",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
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
              "Categorias Suscritas",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
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
              future: productService.getPosts(),
              builder: (context, AsyncSnapshot<List<Product_Model>> snapshot) {
                if (snapshot.hasData) {
                  //items = snapshot.data;
                  data = snapshot.data;
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                  children: data
                      .map((item) => Container(
                          height: 40,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: categoriesSuscribe.contains(item.name)
                                  ? Colors.black
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black, width: 2)),
                          child: Text(
                            item.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: categoriesSuscribe.contains(item.name)
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          )))
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
        return Container();
        break;
      default:
        return Container();
    }
  }
}
