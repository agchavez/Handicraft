import 'package:flutter/material.dart';

class ProductsPages extends StatefulWidget {
  @override
  _ProductsPgaesState createState() => _ProductsPgaesState();
}

class _ProductsPgaesState extends State<ProductsPages> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 22),
              child: Image.asset('assets/icons/search-black-icon.png', width: 20),
            )
          ],
          title:
              Image(width: 140, image: AssetImage('assets/images/logo.png'))),
      body: ListView.builder(
          padding: const EdgeInsets.only(bottom: 50),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.primaries[index % Colors.primaries.length]),
              ),
            );
          }),
    );
  }
}
