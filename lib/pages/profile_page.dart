import 'package:flutter/material.dart';
import 'package:handicraft_app/models/product.dart';
import 'package:handicraft_app/provider/product_service.dart';
import 'package:handicraft_app/provider/storage_service.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/widgets/productNew.dart';

class PorfilePage extends StatefulWidget {
  @override
  _PorfilePageState createState() => _PorfilePageState();
}

class _PorfilePageState extends State<PorfilePage> {
  @override
  Size size;
  int _selectedIndex = 0;

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(body: _createBody());
  }

  Widget _createBody() {
    return SafeArea(
        child: Column(
      children: [
        _createAppbar(),
        _selectedIndex == 0 ? _createLikes() : Container(),
        SizedBox(
          height: 20,
        ),
        _createNavbar(),
        _createinformaction()
      ],
    ));
  }

  Widget _createAppbar() {
    return Container(
      padding: EdgeInsets.all(10),
      height: size.height * 0.32,
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
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.keyboard_control_outlined,
                    textDirection: TextDirection.rtl,
                    color: Colors.white,
                  ))
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
                radius: 37,
                child: Text("AC"),
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
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                )
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
      height: 50,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.link_rounded,
            color: Colors.white,
          ),
          Text(
            "75 Likes",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 14,
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
    return Expanded(
      child: FutureBuilder(
          future: ProductService().getPosts(),
          builder: (context, AsyncSnapshot<List<Product_Model>> snapshot) {
            if (snapshot.hasData) {
              //items = snapshot.data;
              data = snapshot.data;
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                      child: Container(
                        child: ProductNew(
                          product: data[index],
                        ),
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
