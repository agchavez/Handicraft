import 'package:flutter/material.dart';

import 'package:handicraft_app/provider/product_service.dart';

class ProductsPages extends StatefulWidget {
  @override
  _ProductsPgaesState createState() => _ProductsPgaesState();
}

double heightScreen, widthScreen;

class _ProductsPgaesState extends State<ProductsPages> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heightScreen = MediaQuery.of(context).size.height;
    final widthScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 22),
              child:
                  Image.asset('assets/icons/search-black-icon.png', width: 20),
            ),
          ],
          title:
              Image(width: 140, image: AssetImage('assets/images/logo.png'))),
      body: FutureBuilder(
        future: ProductService().getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasError) {
          } else if (snapshot.hasData) {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Container(
                      child: _information(snapshot.data[index]),
                    ),
                  );
                });
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

Widget _information(dynamic data) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _image(data['urlImage']),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.0,
            ),
            Text(
              data['name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              data['location'],
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['cost'],
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                ),
              ],
            ),
          ],
        )
      ],
    ),
  );
}

Widget _image(String url) {
  //getHttp();
  return ClipRRect(
    child: Image.network(
      url,
      height: 135,
      width: 155,
    ),
    borderRadius: BorderRadius.circular(8),
  );
}
