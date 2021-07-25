import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handicraft_app/models/location_model.dart';
import 'package:handicraft_app/pages/login_page.dart';
import 'package:handicraft_app/provider/location_service.dart';
import 'package:handicraft_app/provider/product_service.dart';
import 'package:handicraft_app/utils/selectImage.dart';
import 'package:handicraft_app/widgets/custon_input.dart';
import 'package:handicraft_app/widgets/dropdown_widget.dart';
import 'package:provider/provider.dart';

class NewpProductPage extends StatefulWidget {
  @override
  _NewpProductPageState createState() => _NewpProductPageState();
}

class _NewpProductPageState extends State<NewpProductPage> {
  @override
  LocationModel _countryValue, _cityValue, _provincesValue, categorie, coin;
  List<LocationModel> citys = [],
      contries = [],
      provinces = [],
      coines = [],
      categories = [];
  Size size;
  File image1, image2, image3, image4;
  final descripCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  bool nameError = false,
      image1Error = false,
      check = false,
      coinError = false,
      categorieError = false,
      contrieError = false,
      descError = false,
      amountError = false,
      priceErro = false;
  LocationService locationService;
  ProductService productService;

  @override
  void initState() {
    super.initState();
    locationService = Provider.of<LocationService>(context, listen: false);
    productService = Provider.of<ProductService>(context, listen: false);
    _services();
  }

  _services() async {
    await locationService.getContries().then((value) {
      contries.addAll(value);
    });
    await productService.getCategories().then((value) {
      categories.addAll(value);
    });
    await productService.getCoins().then((value) {
      print(value);
      coines.addAll(value);
    });
    setState(() {
      contries;
    });
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Text(
              'Agregar Producto',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Montserrat'),
            ),
          ),
        ),
        body: SingleChildScrollView(child: _createBody()));
  }

  Widget _createBody() {
    return Container(
      width: size.width,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Imagenes del producto',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  fontSize: 15,
                  fontFamily: 'Montserrat'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _createMenuImages(),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Informacion del producto',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  fontSize: 15,
                  fontFamily: 'Montserrat'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _createFormProduct(),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ubicacion del producto',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  fontSize: 15,
                  fontFamily: 'Montserrat'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _createFormLocation(),
          check
              ? CircularProgressIndicator(
                  color: Colors.black,
                )
              : _createButtom(),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _createFormLocation() {
    return Container(
      child: Column(
        children: [
          _createContrie(),
          SizedBox(
            height: 10,
          ),
          _createProvinces(),
          SizedBox(
            height: 10,
          ),
          _createCity(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _createContrie() {
    return Container(
      height: 50,
      width: size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black)),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton<LocationModel>(
        value: _countryValue,
        items: contries.map((LocationModel location) {
          return new DropdownMenuItem<LocationModel>(
            value: location,
            child: new Text(
              location.name,
              style: new TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) async {
          _provincesValue = null;
          provinces = [];
          _countryValue = value;
          await locationService
              .getProvinces(_countryValue.id)
              .then((value) => provinces.addAll(value));
          setState(() {});
        },
        isExpanded: true,
        hint: Text("Seleccione pais"),
        style: TextStyle(color: Colors.black, fontSize: 16),
        icon: Row(
          children: [
            Icon(
              Icons.arrow_drop_down,
              size: 32,
            ),
            contrieError
                ? Icon(
                    Icons.error_outline_outlined,
                    color: Colors.red,
                  )
                : Container()
          ],
        ),
        iconEnabledColor: Colors.black,
      ),
    );
  }

  Widget _createProvinces() {
    return Container(
      height: 50,
      width: size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black)),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton<LocationModel>(
        value: _provincesValue,
        items: provinces.map((LocationModel location) {
          return new DropdownMenuItem<LocationModel>(
            value: location,
            child: new Text(
              location.name,
              style: new TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) async {
          citys = [];
          _cityValue = null;
          _provincesValue = value;
          await locationService
              .getCity(_countryValue.id, _provincesValue.id)
              .then((value) => citys.addAll(value));
          setState(() {});
        },
        isExpanded: true,
        hint: Text("Seleccione provincia"),
        style: TextStyle(color: Colors.black, fontSize: 16),
        icon: Icon(
          Icons.arrow_drop_down,
          size: 32,
        ),
        iconEnabledColor: Colors.black,
      ),
    );
  }

  Widget _createCity() {
    return Container(
      height: 50,
      width: size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black)),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButton<LocationModel>(
        value: _cityValue,
        items: citys.map((LocationModel location) {
          return new DropdownMenuItem<LocationModel>(
            value: location,
            child: new Text(
              location.name,
              style: new TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _cityValue = value;
          });
        },
        isExpanded: true,
        hint: Text("Seleccione ciudad"),
        style: TextStyle(color: Colors.black, fontSize: 16),
        icon: Icon(
          Icons.arrow_drop_down,
          size: 32,
        ),
        iconEnabledColor: Colors.black,
      ),
    );
  }

  Widget _createMenuImages() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  String path = await showPicker(context);
                  image1 = path != null ? await cropImage(path) : null;
                  if (image1 != null) {
                    setState(() {});
                  }
                },
                child: Container(
                  decoration: image1 != null
                      ? null
                      : BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black38,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                  width: size.width * 0.6,
                  height: size.height * 0.3,
                  child: image1 != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image(
                            width: size.width * 0.6,
                            height: size.height * 0.3,
                            image: FileImage(image1),
                          ),
                        )
                      : image1Error
                          ? Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            )
                          : Icon(Icons.camera_alt_outlined),
                ),
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      String path = await showPicker(context);
                      image2 = path != null ? await cropImage(path) : null;
                      if (image2 != null) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: image2 != null
                          ? null
                          : BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black38,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                      width: size.width * 0.21,
                      height: size.height * 0.09,
                      child: image2 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image(
                                width: size.width * 0.21,
                                height: size.height * 0.09,
                                image: FileImage(image2),
                              ),
                            )
                          : Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String path = await showPicker(context);
                      image3 = path != null ? await cropImage(path) : null;
                      if (image3 != null) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: image3 != null
                          ? null
                          : BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black38,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                      width: size.width * 0.21,
                      height: size.height * 0.09,
                      child: image3 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image(
                                width: size.width * 0.21,
                                height: size.height * 0.09,
                                image: FileImage(image3),
                              ),
                            )
                          : Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String path = await showPicker(context);
                      image4 = path != null ? await cropImage(path) : null;
                      if (image4 != null) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: image4 != null
                          ? null
                          : BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black38,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                      width: size.width * 0.22,
                      height: size.height * 0.09,
                      child: image4 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image(
                                width: size.width * 0.21,
                                height: size.height * 0.09,
                                image: FileImage(image4),
                              ),
                            )
                          : Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _createFormProduct() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 55,
            child: CustonInput(
              placeholder: "Nombre",
              isError: nameError,
              keyBoardtype: TextInputType.emailAddress,
              textController: nameCtrl,
            ),
          ),
          Container(
            height: 140,
            child: CustonInput(
              maxaling: 6,
              isError: descError,
              placeholder: "Descripcion del producto",
              keyBoardtype: TextInputType.emailAddress,
              textController: descripCtrl,
            ),
          ),
          Row(
            children: [
              Container(
                height: 55,
                width: size.width * 0.4,
                child: CustonInput(
                  placeholder: "Precio",
                  isError: priceErro,
                  keyBoardtype: TextInputType.number,
                  textController: priceCtrl,
                ),
              ),
              SizedBox(
                width: size.width * 0.04,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 45,
                width: size.width * 0.4,
                child: DropdownHan(
                    hint: "Modena",
                    error: coinError,
                    value: coin,
                    fnOnchage: setCoins,
                    list: coines,
                    size: 12,
                    width: size.width * 0.4),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 55,
                width: size.width * 0.45,
                child: CustonInput(
                  isError: amountError,
                  placeholder: "Cantidad",
                  keyBoardtype: TextInputType.number,
                  textController: amountCtrl,
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: IconButton(
                    onPressed: () {
                      int temp = 0;
                      amountCtrl.text != ""
                          ? temp = int.parse(amountCtrl.text)
                          : null;
                      temp += 1;
                      amountCtrl.text = temp.toString();
                    },
                    icon: Icon(
                      Icons.add,
                      size: 30,
                    )),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: IconButton(
                    onPressed: () {
                      int temp = 0;
                      amountCtrl.text != ""
                          ? temp = int.parse(amountCtrl.text)
                          : null;
                      temp == 0 ? null : temp -= 1;
                      amountCtrl.text = temp.toString();
                    },
                    icon: Icon(
                      Icons.remove_rounded,
                      size: 30,
                    )),
              )
            ],
          ),
          DropdownHan(
              hint: "Seleccionar categoria",
              height: 55,
              error: categorieError,
              value: categorie,
              fnOnchage: setCategories,
              list: categories,
              width: size.width * 0.9)
        ],
      ),
    );
  }

  void setCoins(LocationModel coinTemp) {
    setState(() {
      coin = coinTemp;
    });
  }

  void setCategories(LocationModel categorieTemp) {
    setState(() {
      categorie = categorieTemp;
    });
  }

  Widget _createButtom() {
    return Container(
      width: size.width * 0.6,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
        onPressed: () {
          setState(() {
            check = true;
          });
          _addProduct();
        },
        child: Text(
          "Agregar producto",
          style: TextStyle(fontSize: 15, fontFamily: 'Montserrat'),
        ),
      ),
    );
  }

  _addProduct() async {
    if (!_validate()) {
      var snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Error! Datos obligatorios!'),
        duration: Duration(milliseconds: 600),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        check = false;
      });
      return;
    }
    final body = {
      "name": nameCtrl.text,
      "description": descripCtrl.text,
      "price": int.parse(priceCtrl.text),
      "quantity": int.parse(amountCtrl.text),
      "coin": coin.id,
      "category": categorie.id,
      "country": _countryValue.id,
      "province": _provincesValue.id,
      "city": _cityValue.id,
    };
    final images = [image1, image2, image3, image4];
    final resp = await productService.addProduct(images, body);
    print("************** $resp");
    setState(() {
      check = false;
    });
  }

  bool _validate() {
    if (nameCtrl.text.length > 5) {
      nameError = false;
    } else {
      nameError = true;
    }
    if (image1 != null) {
      image1Error = false;
    } else {
      image1Error = true;
    }
    if (coin != null) {
      coinError = false;
    } else {
      coinError = true;
    }
    if (_countryValue != null) {
      contrieError = false;
    } else {
      contrieError = true;
    }
    if (categorie != null) {
      categorieError = false;
    } else {
      categorieError = true;
    }
    if (descripCtrl.text.length > 5) {
      descError = false;
    } else {
      descError = true;
    }
    if (amountCtrl.text.length >= 1) {
      amountError = false;
    } else {
      amountError = true;
    }
    if (priceCtrl.text.length >= 1) {
      priceErro = false;
    } else {
      priceErro = true;
    }
    if (amountError ||
        nameError ||
        descError ||
        priceErro ||
        image1Error ||
        contrieError ||
        coinError) {
      return false;
    } else {
      return true;
    }
  }
}
