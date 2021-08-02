import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:handicraft_app/models/product.dart';
import 'package:handicraft_app/pages/photoHero.dart';
import 'package:handicraft_app/provider/product_service.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

RefreshController _refreshController = RefreshController(initialRefresh: false);

class ProductsPages extends StatefulWidget {
  @override
  _ProductsPgaesState createState() => _ProductsPgaesState();
}

double heightScreen, widthScreen;

int cont = 0;

class _ProductsPgaesState extends State<ProductsPages> {
  //List<dynamic> items;
  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //items.add((items.length + 1).toString());
    //PostsRepository().getPosts(1);
    //ProductService().getPosts(2);
    cont = cont + 6;
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
        future: ProductService().getPosts(cont),
        builder: (BuildContext context,
            AsyncSnapshot<List<Product_Model>> snapshot) {
          if (snapshot.hasError) {
          } else if (snapshot.hasData) {
            //items = snapshot.data;
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
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 10, bottom: 0),
                        child: Container(
                          width: 20,
                          child: _information(snapshot.data[index], context),
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
      ),
    );
  }

  Widget _information(Product_Model data, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _image(data.urlImage, context, data),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
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
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _image(String url, BuildContext context, Product_Model data) {
    timeDilation = 3.0;

    //getHttp();
    return PhotoHero(
      photo: url,
      width: 135,
      height: 130,
      onTap: () {
        setState(() {
          Navigator.pushNamed(context, 'details', arguments: data.idProduct);
        });
      },
    );
  }
}
