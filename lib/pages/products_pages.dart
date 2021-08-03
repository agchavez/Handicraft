import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/product.dart';
import 'package:handicraft_app/provider/product_service.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

RefreshController _refreshController = RefreshController(initialRefresh: false);

class ProductsPages extends StatefulWidget {
  @override
  _ProductsPgaesState createState() => _ProductsPgaesState();
}

double heightScreen, widthScreen;

class _ProductsPgaesState extends State<ProductsPages> {
  //List<dynamic> items;
  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
              child: Row(
                children: [
                  Text(
                    "Productos",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                      fontSize: 18
                    ),
                  )
                ],
              ),
          ),
          Expanded(
              child: FutureBuilder(
                future: ProductService().getPosts(),
                builder: (BuildContext context, AsyncSnapshot<List<Product_Model>> snapshot) {
                  if (snapshot.hasError) {
                  } else if (snapshot.hasData) {
                    return SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(),
                        footer: CustomFooter(
                          builder: (BuildContext context, LoadStatus mode) {
                            Widget body;
                            if (mode == LoadStatus.idle) {
                              body = Text("pull up load");
                            } else if (mode == LoadStatus.loading) {
                              body = CupertinoActivityIndicator();
                            } else if (mode == LoadStatus.failed) {
                              body = Text("Load Failed!Click retry!");
                            } else if (mode == LoadStatus.canLoading) {
                              body = Text("release to load more");
                            } else {
                              body = Text("No more Data");
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child: body),
                            );
                          },
                        ),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        physics: ScrollPhysics(),
                        child: GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.78
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                child: Container(
                                  child: _information(snapshot.data[index]),
                                ),
                              );
                            }));
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                },
              )
          )
        ],
      ),
    );
  }
}

Widget _information(Product_Model data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        children: [
          _image(data.urlImage),
        ],
      ),
      SizedBox(
        height: 5.0,
      ),
      Row(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 5.0, left: 5.0),
              child: Text(
                data.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    fontFamily: 'Montserrat'
                ),
              ),
          )
        ],
      ),
      SizedBox(
        height: 3.0,
      ),
      Row(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                data.location,
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 13,
                    fontFamily: 'Montserrat',
                    decoration: TextDecoration.underline,
                ),
              ),
          )
        ],
      ),
      SizedBox(
        height: 4.0,
      ),
      Row(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                'Precio: ${data.cost}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Montserrat',
                    color: Color(0xFFC4C4C4),
                ),
              ),
          )
        ],
      )
    ],
  );

    Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      _image(data.urlImage),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 1.0,
          ),
          Text(
            data.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11),
          ),
          Text(
            data.location,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.cost,
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 10),
              ),
            ],
          ),
        ],
      )
    ],
  );
}

Widget _image(String url) {
  return Container(
    height: 140,
    width: 140,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.fill
        )
    ),
  );
}
