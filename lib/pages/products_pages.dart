import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //items.add((items.length + 1).toString());
    //PostsRepository().getPosts(1);
    //ProductService().getPosts(2);

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
        future: ProductService().getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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
                            left: 20, right: 20, bottom: 8),
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
      ),
    );
  }
}

Widget _information(dynamic data) {
  return Column(
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
          Text(
            data['location'],
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
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
