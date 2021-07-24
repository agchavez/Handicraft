import 'package:flutter/material.dart';
import 'package:handicraft_app/provider/product_service2.dart';

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
        future: PostsRepository().getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasError) {
            print('ERROR');
          } else if (snapshot.hasData) {
            print(snapshot.data);
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: _information(snapshot.data[index]),
                    ),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

Widget _information(dynamic data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      _image(),
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['name'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
          Text(
            data['location'],
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['cost'],
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 10),
              ),
            ],
          ),
        ],
      )
    ],
  );
}

Widget _image() {
  //getHttp();
  return ClipRRect(
    child: Image(
      image: AssetImage('assets/images/product.jpg'),
    ),
    borderRadius: BorderRadius.circular(8),
  );
}
