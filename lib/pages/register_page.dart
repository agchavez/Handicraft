import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:handicraft_app/provider/auth_service.dart';

import 'package:handicraft_app/utils/util.dart' as utils;
import 'package:provider/provider.dart';
import 'package:handicraft_app/widgets/image.dart';

import 'package:handicraft_app/models/companie.dart';
import 'package:handicraft_app/models/acount_user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:handicraft_app/global/enviroment.dart';
import 'package:handicraft_app/models/location_model.dart';
import 'package:handicraft_app/provider/location_service.dart';
import 'package:handicraft_app/provider/product_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  final form2key = GlobalKey<FormState>();
  UserAccountModel _user = new UserAccountModel();
  CompanieAccountModel _companie = new CompanieAccountModel();

  File foto, newImage;
  bool _typeAcount = false;
  bool _showpasword = true;
  bool check = false;
  bool vefiryEmail = false;
  bool nowCompanie = false;
  TextEditingController _textDescriptionController = TextEditingController();
  double currentOpacity = 1.0;
  bool _validateDescription = false;
  final dio = Dio();

  LocationModel _countryValue, _cityValue, _provinceValue;
  List<LocationModel> cities = [], contries = [], provinces = [];
  LocationService locationService;
  ProductService productService;
  final picker = ImagePicker();
  Size size = Size(1000, 5000);
  final auth = FirebaseAuth.instance;
  User user;

  @override
  void initState() {
    super.initState();
    locationService = Provider.of<LocationService>(context, listen: false);
    _services();
  }

  @override
  void dispose() {
    super.dispose();
    _validateDescription = false;
    formkey.currentState?.reset();
    form2key.currentState?.reset();
    vefiryEmail = false;
  }

  _services() async {
    await locationService.getContries().then((value) {
      contries.addAll(value);
    });

    setState(() {
      contries;
    });
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: FloatingActionButton(
            child: Image.asset(
              'assets/icons/back-black-icon.png',
              width: 7.0,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.popAndPushNamed(context, 'home');
            },
          ),
          height: 43.0,
          width: 43.0,
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: PageTransitionSwitcher(
          duration: Duration(seconds: 1),
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child:
              vefiryEmail ? _createVerifyEmailView() : _createFormsInteract(),
        ),
      ),
    );
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              height: size.height * 0.30,
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Libreria de fotos'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camara'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _logo() {
    return Container(
        child: Column(
      children: [
        Column(
          children: [
            Image(
                height: size.height * 0.06,
                image: AssetImage('assets/images/logo.png')),
            Text(
              "¡Productos que te encantarán!.",
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            )
          ],
        ),
      ],
    ));
  }

  /*Widget _createImg(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _navigateAndDisplaySelection(context);
        //Navigator.pushNamed(context, "example");
      },
      child: Container(
        width: size.width * 0.4,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: FadeInImage(
                height: 120,
                width: 140,
                fit: BoxFit.fitHeight,
                placeholder: AssetImage("assets/images/Spinner-1s-200px.gif"),
                image: _mostrarFoto(""))),
      ),
    );
  }*/

/*IMAGEN*/

  _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    imageFile = pickedFile;
    File file = await cropImage();
    print(file);
    if (file != null) {
      setSt(file);
    }
  }

  Widget _createFormsInteract() {
    return SafeArea(
        child: Container(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.02,
          ),
          _logo(),
          SizedBox(
            height: 15,
          ),
          /*Center(
              child: GestureDetector(
                onTap: () {
                  showPicker(context);
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFFFFFFF),
                  child: tempimageFileList != null
                      ? previewImages()
                      : Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF000000),
                              borderRadius: BorderRadius.circular(50)),
                          width: 50,
                          height: 50,
                          child: Image.asset('assets/icons/camera-icon.png', width: 10.0,)
                        ),
                ),
              ),
            ),*/
          SizedBox(
            height: 15,
          ),
          Stack(
            children: [
              AnimatedOpacity(
                opacity: currentOpacity,
                duration: Duration(milliseconds: 600),
                child: nowCompanie ? _createFormCompanies() : _createForm(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _createSelect(),
          SizedBox(
            height: 10,
          ),
          // if (_typeAcount) _createFormCompanies(),
          !check
              ? _createBottom(context)
              : CircularProgressIndicator(
                  color: Colors.black,
                ),
          SizedBox(
            height: 10.0,
          ),
          nowCompanie
              ? _createBackButton(context)
              : SizedBox(
                  height: 5,
                ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿Ya tienes una cuenta?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, 'login');
                    },
                    child: Text(
                      " Iniciar Sesión",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  )
                ],
              )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: size.width * 0.73,
            child: Text(
              "Al hacer clic en iniciar sesión o continuar con google, acepta los términos de uso de Handicraft y política de privacidad.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          SizedBox(
            height: 50.0,
          )
        ],
      ),
    ));
  }

  Widget _createVerifyEmailView() {
    return SafeArea(
      child: Container(
          height: size.height * 0.85,
          child: Padding(
            padding: EdgeInsets.only(
                top: 20.0, right: 25.0, left: 25.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/urban-mailbox.png',
                      scale: 3.5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  '¡Revisa tu correo electrónico!.',
                  style: TextStyle(
                    color: Color(0xFFB8B7B7),
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: new TextSpan(
                      style: new TextStyle(
                        color: Color(0xFFC4C4C4),
                        fontFamily: 'Montserrat',
                        fontSize: 11.5,
                        height: 1.1,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: "¡Enhorabuena, "),
                        TextSpan(
                            text: "${_user.firstname} ${_user.lastname} ",
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: 'Bienvenido a Handicraft!'),
                        TextSpan(
                            text:
                                ' hemos enviado un correo de verificacion a tu email '),
                        TextSpan(
                            text: "${_user.email}",
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                ', por favor confirma tu email para continuar.'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Container(
                      width: size.width * 0.75,
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Continuar')])),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 2.0,
                  color: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "login");
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  child: Container(
                      width: size.width * 0.75,
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  vefiryEmail = false;
                                });
                                // auth.currentUser.sendEmailVerification();
                              },
                              child: Text(
                                'Reenviar confirmación',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ])),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.white, width: 3.0),
                  ),
                  elevation: 0.0,
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    setState(() {
                      currentOpacity = 0.0;
                    });
                    Future.delayed(const Duration(milliseconds: 600), () {
                      form2key.currentState.save();
                      setState(() {
                        nowCompanie = !nowCompanie;
                        currentOpacity = 1.0;
                      });
                    });
                  },
                ),
              ],
            ),
          )),
    );
  }

  _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    imageFile = pickedFile;
    File file = await cropImage();
    print(file);
    if (file != null) {
      setSt(file);
    }
  }

  void setSt(File croppedFile) {
    setState(() {
      image = croppedFile;
    });
  }

  void _clearImage() {
    setState(() {
      image = null;
    });
  }

/**/
  Widget _createForm() {
    return SingleChildScrollView(
      child: Form(
          key: formkey,
          child: Column(
            children: [
              _createName(),
              SizedBox(
                height: 10,
              ),
              _createLastName(),
              SizedBox(
                height: 10,
              ),
              _createEmail(),
              SizedBox(
                height: 10,
              ),
              _createPassword(),
              SizedBox(
                height: 10,
              ),
              _createPhoneNumber()
            ],
          )),
    );
  }

  Widget _createName() {
    return Container(
        width: size.width * 0.75,
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: TextFormField(
            scrollPadding: EdgeInsets.symmetric(vertical: 0.0),
            style: TextStyle(decorationColor: Colors.white),
            keyboardType: TextInputType.name,
            initialValue: _user.firstname,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 2.5,
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 2.5,
                  color: Colors.black,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 100, color: Colors.white10),
                  borderRadius: BorderRadius.circular(10.0)),
              hintText: 'Nombre',
            ),
            onSaved: (value) => _user.firstname = value,
            validator: (value) {
              if (value.isEmpty || utils.isNumeric(value)) {
                return 'Nombre obligatorio';
              } else {
                return null;
              }
            }));
  }

  Widget _createLastName() {
    return Container(
        width: size.width * 0.75,
        child: TextFormField(
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          initialValue: _user.lastname,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.white10),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Apellido',
          ),
          onSaved: (value) => _user.lastname = value,
          validator: (value) {
            if (value.isEmpty || utils.isNumeric(value)) {
              return 'Apellido obligatorio';
            } else {
              return null;
            }
          },
        ));
  }

  Widget _createEmail() {
    return Container(
        width: size.width * 0.75,
        child: TextFormField(
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          initialValue: _user.email,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Correo electrónico',
          ),
          onSaved: (value) => {_user.email = value.toString(), print("object")},
          validator: (value) {
            if (!utils.validatorEmail(value.toString())) {
              return 'Correo no válido';
            } else {
              return null;
            }
          },
        ));
  }

  Widget _createPassword() {
    return Container(
        width: size.width * 0.75,
        child: TextFormField(
          obscureText: _showpasword,
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          initialValue: _user.password,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            suffixIcon: GestureDetector(
              child: _showpasword
                  ? Icon(
                      Icons.lock,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.lock_open,
                      color: Colors.black,
                    ),
              onTap: () => {
                setState(() {
                  _showpasword = !_showpasword;
                })
              },
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2.5, color: Colors.black),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Contraseña',
          ),
          onSaved: (value1) => _user.password = value1,
          validator: (value) {
            if (value.isEmpty) {
              return 'Contraseña obligatoria';
            } else {
              return null;
            }
          },
        ));
  }

  Widget _createSelect() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.14),
      child: Row(
        children: [
          Text(
            "Cuenta de empresa",
            style: TextStyle(fontSize: 13, fontFamily: 'Montserrat'),
          ),
          SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _typeAcount = !_typeAcount;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(12)),
              child: CustomSwitchButton(
                backgroundColor: _typeAcount ? Colors.black : Colors.white10,
                unCheckedColor: Colors.black,
                animationDuration: Duration(milliseconds: 400),
                checkedColor: Colors.white,
                checked: _typeAcount,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createBottom(BuildContext context) {
    return Container(
      width: size.width * 0.75,
      child: RaisedButton(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_typeAcount
                      ? (nowCompanie ? 'Registrarme' : 'Siguiente')
                      : 'Registrarme'),
                ])),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        color: Colors.black,
        textColor: Colors.white,
        onPressed: () => _viewEventSignUpOrCompanie(),
      ),
    );
  }

  Widget _createBackButton(BuildContext context) {
    return Container(
      width: size.width * 0.75,
      child: RaisedButton(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Regresar',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ])),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.black, width: 3.0),
        ),
        elevation: 2.0,
        color: Colors.white,
        textColor: Colors.black,
        onPressed: () {
          setState(() {
            currentOpacity = 0.0;
          });
          Future.delayed(const Duration(milliseconds: 600), () {
            form2key.currentState.save();
            setState(() {
              nowCompanie = !nowCompanie;
              currentOpacity = 1.0;
            });
          });
        },
      ),
    );
  }

  Widget _viewEventSignUpOrCompanie() {
    if (_typeAcount && !nowCompanie) {
      if (formkey.currentState.validate()) {
        formkey.currentState.save();
        setState(() {
          currentOpacity = 0.0;
        });
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            nowCompanie = !nowCompanie;
            currentOpacity = 1.0;
          });
        });
      }
    } else {
      _createAcount();
    }
  }

  Widget _createFormCompanies() {
    return Container(
      child: Form(
          key: form2key,
          child: Column(
            children: [
              _createNameCompanie(),
              SizedBox(
                height: 10,
              ),
              _createCountry(),
              SizedBox(
                height: 10,
              ),
              _createState(),
              SizedBox(
                height: 10,
              ),
              _createCity(),
              SizedBox(
                height: 10,
              ),
              _createDescription(),
              SizedBox(
                height: 5,
              ),
            ],
          )),
    );
  }

  Widget _createNameCompanie() {
    return Container(
        width: size.width * 0.75,
        height: 58,
        child: TextFormField(
          style: TextStyle(
            decorationColor: Colors.white,
          ),
          keyboardType: TextInputType.name,
          initialValue: _companie.name,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Nombre de la empresa',
          ),
          onSaved: (value) => _companie.name = value,
          validator: (value) {
            if (value.isEmpty || utils.isNumeric(value)) {
              return 'Campo obligatorio';
            } else {
              return null;
            }
          },
        ));
  }

  Widget _createDescription() {
    return Container(
        width: size.width * 0.75,
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: TextFormField(
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.multiline,
          initialValue: _companie.description,
          maxLines: null,
          maxLength: 300,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.white10),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Descripcion',
          ),
          onSaved: (value) => _companie.description = value,
          validator: (value) {
            if (value.length > 300) {
              return 'Maximo de caracteres 300';
            } else {
              return null;
            }
          },
        ));
  }

  Widget _createPhoneNumber() {
    return Container(
        width: size.width * 0.75,
        child: TextFormField(
          validator: (value) {
            print(value.length);
            if (value.length != 8) {
              return "Teléfono no valido";
            } else {
              return null;
            }
          },
          style: TextStyle(
            decorationColor: Colors.white,
          ),
          keyboardType: TextInputType.phone,
          initialValue: _user.phone,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 2.5,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Teléfono',
          ),
          onSaved: (value) => {_user.phone = value.toString(), print("object")},
        ));
  }

  Widget _createCountry() {
    return Container(
      width: size.width * 0.75,
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2.5, color: Colors.black)),
      child: new DropdownButtonHideUnderline(
          child: DropdownButton<LocationModel>(
        value: _countryValue,
        items: contries.map((LocationModel location) {
          return new DropdownMenuItem<LocationModel>(
              value: location,
              child: new Text(
                location.name,
                style: new TextStyle(color: Colors.black),
              ));
        }).toList(),
        onChanged: (value) async {
          _provinceValue = null;
          provinces = [];
          _countryValue = value;
          await locationService
              .getProvinces(_countryValue.id)
              .then((provincesRes) => provinces.addAll(provincesRes));
          setState(() {});
        },
        isExpanded: true,
        hint: Text('Seleccione su pais'),
        style: TextStyle(color: Colors.black, fontSize: 16),
        icon: Row(
          children: [
            Icon(
              Icons.arrow_drop_down,
              size: 32,
            )
          ],
        ),
        iconEnabledColor: Colors.black,
      )),
    );
  }

  Widget _createState() {
    return Container(
      width: size.width * 0.75,
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2.5, color: Colors.black)),
      child: new DropdownButtonHideUnderline(
          child: DropdownButton<LocationModel>(
        value: _provinceValue,
        items: provinces.map((LocationModel province) {
          return new DropdownMenuItem<LocationModel>(
              value: province,
              child: new Text(
                province.name,
                style: new TextStyle(color: Colors.black),
              ));
        }).toList(),
        onChanged: (value) async {
          cities = [];
          _cityValue = null;
          _provinceValue = value;
          await locationService
              .getCity(_countryValue.id, _provinceValue.id)
              .then((value) => cities.addAll(value));
          setState(() {});
        },
        isExpanded: true,
        hint: Text('Seleccione su provincia'),
        style: TextStyle(color: Colors.black, fontSize: 16),
        icon: Row(
          children: [
            Icon(
              Icons.arrow_drop_down,
              size: 32,
            )
          ],
        ),
        iconEnabledColor: Colors.black,
      )),
    );
  }

  Widget _createCity() {
    return Container(
      width: size.width * 0.75,
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2.5, color: Colors.black)),
      child: new DropdownButtonHideUnderline(
          child: DropdownButton<LocationModel>(
        value: _cityValue,
        items: cities.map((LocationModel city) {
          return new DropdownMenuItem<LocationModel>(
              value: city,
              child: new Text(
                city.name,
                style: new TextStyle(color: Colors.black),
              ));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _cityValue = value;
          });
        },
        isExpanded: true,
        hint: Text('Seleccione su ciudad'),
        style: TextStyle(color: Colors.black, fontSize: 16),
        icon: Row(
          children: [
            Icon(
              Icons.arrow_drop_down,
              size: 32,
            )
          ],
        ),
        iconEnabledColor: Colors.black,
      )),
    );
  }

  _createAcount() async {
    setState(() {
      check = !check;
    });

    if (!_typeAcount) {
      if (!formkey.currentState.validate()) {
        setState(() {
          check = !check;
        });
        return;
      }
      formkey.currentState.save();
    } else {
      if (!form2key.currentState.validate()) {
        setState(() {
          check = !check;
        });
        return;
      }
      form2key.currentState.save();
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.register(_user).then((userResponse) async {
      Map<String, dynamic> body = {
        'idUser': FirebaseAuth.instance.currentUser.uid,
        'firstName': _user.firstname.trim(),
        'lastName': _user.lastname.trim(),
        'email': _user.email.trim(),
        'phoneNumber': _user.phone.trim(),
        'photoProfile':
            'https://firebasestorage.googleapis.com/v0/b/handicraft-app.appspot.com/o/image%2Fprofile_pictures%2Fdefault_profile.png?alt=media&token=3610e4eb-44a4-4357-b877-f6bd16904aff'
      };

      if (_typeAcount) {
        body["companyName"] = _companie.name.trim();
        body["country"] = _countryValue.id;
        body["province"] = _provinceValue.id;
        body["city"] = _cityValue.id;
        body["description"] = _companie.description;
      }

      print(body);
      Response response = await dio.post(
          _typeAcount
              ? "${Enviroment.apiurl}/user/user-company"
              : "${Enviroment.apiurl}/user",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(body));

      if (response.statusCode == 200) {
        authService.sendEmailVerification().then((send) async {
          if (send) {
            check = !check;
            vefiryEmail = !vefiryEmail;
            await authService.signOut();
            setState(() {});
          }
        });
        return true;
      } else {
        setState(() {
          check = !check;
        });
        return false;
      }

      _mostrarFoto(data) {
        if (data == '' || data.fotoUrl == null) {
          return AssetImage('assets/images/unnamed.png');
        } else {
          return NetworkImage(
            data.fotoUrl,
          );
        }
      }

      _navigateAndDisplaySelection(BuildContext context) async {}
    });
  }
}
