import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/location_model.dart';
import 'package:handicraft_app/pages/login_page.dart';
import 'package:handicraft_app/provider/location_service.dart';
import 'package:handicraft_app/provider/product_service.dart';
import 'package:handicraft_app/utils/selectImage.dart';
import 'package:handicraft_app/utils/util.dart';
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
  List<File> productImages = [];
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
      cityError = false,
      provinceError = false,
      descError = false,
      amountError = false,
      priceErro = false;
  LocationService locationService;
  ProductService productService;
  List<String> categoriesSuscribe = [];
  int selectedCategory;

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
          title: Row(
            children: [
              Container(
                height: size.height * 0.021,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Text(
                  'Nuevo Producto',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Montserrat'),
                ),
              ),
              SizedBox(
                width: size.width * 0.21,
              ),
              Container(
                height: size.height * 0.06,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black),
                  ),
                  color: Colors.black,
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height * 0.02,
                    color: Colors.black,
                    width: size.width * 0.2,
                    child: check
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Publicar",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  onPressed: () {
                    setState(() {
                      check = true;
                    });
                    _addProduct();
                  },
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(child: _createBody()));
  }

  Widget _createBody() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Imagenes del producto',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFFC4C4C4),
                fontSize: 15,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          _createMenuImages(),
          SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Informacion del producto',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFC4C4C4),
                  fontSize: 15,
                  fontFamily: 'Montserrat'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _createFormProduct(),
          SizedBox(
            height: 15,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ubicacion',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFC4C4C4),
                  fontSize: 15,
                  fontFamily: 'Montserrat'),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          _createFormLocation(),
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
          _createCountry(),
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

  Widget _createCountry() {
    return Container(
      width: size.width * 0.9,
      child: DropdownButtonFormField<LocationModel>(
          value: _countryValue,
          itemHeight: size.height * 0.07,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(width: 2.5, color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(width: 2.5, color: Colors.black)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 100, color: Colors.white10))),
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
            FocusScope.of(context).requestFocus(new FocusNode());
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
          validator: (value) {
            if (value == null) {
              return "Campo requerido";
            } else {
              return null;
            }
          }),
    );
  }

  Widget _createProvinces() {
    return Container(
        width: size.width * 0.9,
        child: DropdownButtonFormField<LocationModel>(
            value: _provincesValue,
            itemHeight: size.height * 0.07,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(width: 2.5, color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(width: 2.5, color: Colors.black)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 100, color: Colors.white10))),
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
            icon: Row(
              children: [
                Icon(
                  Icons.arrow_drop_down,
                  size: 32,
                ),
                provinceError
                    ? Icon(
                        Icons.error_outline_outlined,
                        color: Colors.red,
                      )
                    : Container()
              ],
            ),
            iconEnabledColor: Colors.black,
            validator: (value) {
              if (value == null) {
                return "Campo requerido";
              } else {
                return null;
              }
            }));
  }

  Widget _createCity() {
    return Container(
      width: size.width * 0.9,
      child: DropdownButtonFormField<LocationModel>(
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(width: 2.5, color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(width: 2.5, color: Colors.black)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 100, color: Colors.white10))),
          value: _cityValue,
          itemHeight: size.height * 0.07,
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
          icon: Row(
            children: [
              Icon(
                Icons.arrow_drop_down,
                size: 32,
              ),
              cityError
                  ? Icon(
                      Icons.error_outline_outlined,
                      color: Colors.red,
                    )
                  : Container()
            ],
          ),
          iconEnabledColor: Colors.black,
          validator: (value) {
            if (value == null) {
              return "Campo requerido";
            } else {
              return null;
            }
          }),
    );
  }

  Widget _createMenuImages() {
    return Container(
      height: size.height * 0.25,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: false,
        children: [
          for (var product in productImages)
            Row(
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      width: 175,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: FileImage(product), fit: BoxFit.fill)),
                    ),
                    Positioned(
                      width: size.width * 0.94,
                      top: -0.2,
                      child: GestureDetector(
                        onTap: () {
                          _removeItem(product);
                        },
                        child: Container(
                          width: 25.0,
                          height: 25.0,
                          child: Image.asset('assets/icons/remove-icon.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                )
              ],
            ),
          productImages.length != 4
              ? GestureDetector(
                  onTap: () async {
                    String path = await showPicker(context);
                    if (path != null) {
                      productImages.add(await cropImage(path));
                      setState(() {
                        image1Error = false;
                      });
                    }
                  },
                  child: Container(
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: image1Error
                                  ? BoxDecoration(
                                      color: Color(0xFF08E6F4),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 2,
                                      ))
                                  : BoxDecoration(
                                      color: Color(0xFF08E6F4),
                                      border: Border.all(
                                        color: Color(0xFF08E6F4),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12)),
                              width: size.width * 0.5,
                              height: size.height * 0.25,
                              child: image1 != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image(
                                        width: size.width * 0.6,
                                        height: size.height * 0.3,
                                        image: FileImage(image1),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.14,
                                            ),
                                            Image.asset(
                                                'assets/images/add-picture.png')
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            "Agregar imagen",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat",
                                              fontSize: 13,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  _removeItem(value) {
    productImages.remove(value);
    setState(() {});
  }

  Widget _createFormProduct() {
    return Container(
      child: Column(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.1,
            child: CustonInput(
              placeholder: "Titulo del producto",
              isError: nameError,
              keyBoardtype: TextInputType.emailAddress,
              textController: nameCtrl,
            ),
          ),
          Container(
            width: size.width,
            height: size.height * 0.1,
            child: CustonInput(
              placeholder: "Precio",
              isError: priceErro,
              keyBoardtype: TextInputType.number,
              textController: priceCtrl,
            ),
          ),
          Container(
            height: size.height * 0.12,
            width: size.width,
            child: DropdownHan(
                hint: "Modena",
                error: coinError,
                value: coin,
                fnOnchage: setCoins,
                list: coines,
                size: 12,
                width: size.width * 0.4),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: size.height * 0.12,
                width: size.width * 0.61,
                child: CustonInput(
                  isError: amountError,
                  placeholder: "Cantidad",
                  keyBoardtype: TextInputType.number,
                  textController: amountCtrl,
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: size.height * 0.04),
                margin: EdgeInsets.only(left: 20, right: 10),
                child: GestureDetector(
                    onTap: () {
                      int temp = 0;
                      amountCtrl.text != ""
                          ? temp = int.parse(amountCtrl.text)
                          : null;
                      temp += 1;
                      amountCtrl.text = temp.toString();
                    },
                    child: Container(
                      height: 16,
                      width: 16,
                      child: Image.asset('assets/icons/plus-icon.png'),
                    )),
              ),
              Container(
                padding: EdgeInsets.only(bottom: size.height * 0.04),
                margin: EdgeInsets.only(left: 10, right: 10),
                child: GestureDetector(
                    onTap: () {
                      int temp = 0;
                      amountCtrl.text != ""
                          ? temp = int.parse(amountCtrl.text)
                          : null;
                      temp == 0 ? null : temp -= 1;
                      amountCtrl.text = temp.toString();
                    },
                    child: Container(
                      height: 18,
                      width: 18,
                      child: Image.asset('assets/icons/wade-minus-icon.png'),
                    )),
              )
            ],
          ),
          Container(
            height: size.height * 0.13,
            child: CustonInput(
              maxaling: null,
              isError: descError,
              placeholder: "Descripcion del producto",
              keyBoardtype: TextInputType.emailAddress,
              textController: descripCtrl,
              maxLengthDescription: 300,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Agrega este producto a una categoria',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFC4C4C4),
                  fontSize: 15,
                  fontFamily: 'Montserrat'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
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
                                  categoriesSuscribe.remove(item.name);
                                  selectedCategory = null;
                                } else if (categoriesSuscribe.length == 1) {
                                  return;
                                } else {
                                  categoriesSuscribe.add(item.name);
                                  selectedCategory = item.id;
                                }
                                setState(() {});
                              },
                              child: Container(
                                  height: 40,
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color:
                                          categoriesSuscribe.contains(item.name)
                                              ? Colors.black
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.black, width: 2)),
                                  child: Text(
                                    item.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: categoriesSuscribe
                                                .contains(item.name)
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
                return Center(child: Text("Error al obtener las categorias"));
              } else {
                return Center(
                  child: Container(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  void setCoins(LocationModel coinTemp) {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      coin = coinTemp;
    });
  }

  void setCategories(LocationModel categorieTemp) {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      categorie = categorieTemp;
    });
  }

  _addProduct() async {
    if (!_validate()) {
      showSnacbar(
          Text('Error! Datos obligatorios!'),
          Colors.red,
          Icon(
            Icons.error_outline_outlined,
            size: 120,
          ),
          context);
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
      "category": selectedCategory,
      "country": _countryValue.id,
      "province": _provincesValue.id,
      "city": _cityValue.id,
    };
    final images = productImages;
    final resp = await productService.addProduct(images, body);
    if (resp) {
      clearData();
      showSnacbar(
          Text(
            'Producto agregado',
            style: TextStyle(color: Colors.black),
          ),
          Colors.white,
          Icon(Icons.check_box_outline_blank_outlined),
          context);
    } else {}
    setState(() {
      check = false;
    });
  }

  void clearData() {
    nameCtrl.text = "";
    descripCtrl.text = "";
    priceCtrl.text = "";
    amountCtrl.text = "";
    productImages = [];
    coin = null;
    categoriesSuscribe = [];
    categorie = null;
    _countryValue = null;
    _provincesValue = null;
    _cityValue = null;
  }

  bool _validate() {
    if (nameCtrl.text.length > 5) {
      nameError = false;
    } else {
      nameError = true;
    }

    if (productImages.length != 0) {
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
    if (_provincesValue != null) {
      provinceError = false;
    } else {
      provinceError = true;
    }
    if (_cityValue != null) {
      cityError = false;
    } else {
      cityError = true;
    }

    if (selectedCategory != null) {
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
        provinceError ||
        cityError ||
        coinError) {
      return false;
    } else {
      return true;
    }
  }
}
