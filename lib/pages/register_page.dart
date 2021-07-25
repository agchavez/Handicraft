import 'dart:io';
import 'dart:convert' as convert;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:handicraft_app/utils/alerts.dart';

import 'package:handicraft_app/utils/util.dart' as utils;
import 'package:provider/provider.dart';
import 'package:handicraft_app/widgets/image.dart';

import 'package:handicraft_app/models/companie.dart';
import 'package:handicraft_app/models/acount_user.dart';
//import 'package:handicraft_app/widgets/image.dart' as imageWid;

// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

  final formkey = GlobalKey<FormState>();
  final form2key = GlobalKey<FormState>();
  UserAccountModel _user = new UserAccountModel();
  CompanieAccountModel _companie = new CompanieAccountModel();

  File foto, newImage;
  bool _typeAcount = false;
  bool _showpasword = true;
  bool check = false;
  bool nowCompanie = false;
  double currentOpacity = 1.0;

  String _countryValue = 'Pais';
  String _cityValue = 'Ciudad';
  String _stateValue = 'Provincia';

class _RegisterPageState extends State<RegisterPage> {
  final picker = ImagePicker();
  Size size = Size(1000, 5000);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(child:
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 30.0, left: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'home');
                      },
                      child: Image.asset(
                          'assets/icons/back-black-icon.png', width: 10.0),
                    )
                )
              ],
            ),
            ),
            SizedBox(
              height: size.height * 0.03,
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
            _createForm(),
            _createFormCompanies(),
            // Stack(
            //   children: [
            //     AnimatedOpacity(
            //       opacity: currentOpacity,
            //       duration: Duration(milliseconds: 600),
            //       child: nowCompanie ? _createFormCompanies() : _createForm(),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 10,
            ),
            _createSelect(),
            SizedBox(
              height: 10,
            ),
            // if (_typeAcount) _createFormCompanies(),
            SizedBox(
              height: 20,
            ),
            !check
                ? _createBottom(context)
                : CircularProgressIndicator(
              color: Colors.black,
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
                          onTap: (){
                            _createAcount();
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
    print('here');
    final pickedFile =
    await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    imageFile = pickedFile;
    File file = await cropImage();
    print(file);
    if (file != null) {
      setSt(file);
    }
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
                return 'Campo obligatorio';
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
              return 'Campo obligatorio';
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
              onTap: () =>
              {
                setState(() {
                  _showpasword = !_showpasword;
                })
              },
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
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
            style: TextStyle(fontSize: 13,
                fontFamily: 'Montserrat'),
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
                  Text(_typeAcount ? 'Siguiente' : 'Registrarme'),
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

  Widget _viewEventSignUpOrCompanie() {
    if (_typeAcount) {
      setState(() {
        currentOpacity = 0.0;
      });
      var future = new Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          nowCompanie = !nowCompanie;
          currentOpacity = 1.0;
        });
      });
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
              _createCity()
            ],
          )),
    );
  }

  Widget _createNameCompanie() {
    return Container(
        width: size.width * 0.75,
        child: TextFormField(
            validator: (value) {
              if (value.isEmpty || utils.isNumeric(value)) {
                return 'Campo obligatorio';
              } else {
                return null;
              }
            },
            style: TextStyle(
              decorationColor: Colors.white,
            ),
            keyboardType: TextInputType.name,
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
        ));
  }

  Widget _createPhoneNumber() {
    return Container(
        width: size.width * 0.75,
        child: TextFormField(
          validator: (value) {
            print(value.length);
            if (value.length != 8) {
              return "Numero no valido";
            } else {
              return null;
            }
          },
          style: TextStyle(
            decorationColor: Colors.white,
          ),
          keyboardType: TextInputType.phone,
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
            hintText: 'Numero de telefono',
          ),
          onSaved: (value) => {_user.phone = value.toString(), print("object")},
        ));
  }

  Widget _createCountry() {
    return Container(
      width: size.width * 0.75,
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2.5, color: Colors.black)),
      child: Row(
        children: [
          Container(
            child: DropdownButton<String>(
                value: _countryValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 35,
                onChanged: (newValue) {
                  setState(() {
                    _countryValue = newValue.toString();
                  });
                },
                items: <String>[
                  'Pais',
                  'La Paz',
                  'Francisco Morazan',
                  'Cortes'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }


  Widget _createCity() {
    return Container(
      width: size.width * 0.75,
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2.5, color: Colors.black)),
      child: Row(
        children: [
          Container(
            child: DropdownButton<String>(
                value: _cityValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 35,
                onChanged: (newValue) {
                  setState(() {
                    _cityValue = newValue.toString();
                  });
                },
                items: <String>[
                  'Ciudad',
                  'La Paz',
                  'Francisco Morazan',
                  'Cortes'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }

  Widget _createState() {
    return Container(
      width: size.width * 0.75,
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2.5, color: Colors.black)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: DropdownButton<String>(
                value: _stateValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 35,
                onChanged: (newValue) {
                  setState(() {
                    _stateValue = newValue.toString();
                  });
                },
                items: <String>[
                  'Provincia',
                  'La Paz',
                  'Marcala',
                  'Guajiquiro',
                  'Tutule'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }

  _createAcount() async {
    setState(() {
      check = !check;
    });

    if (!formkey.currentState.validate()) {
      if (_typeAcount) {
        if (form2key.currentState.validate()) {
          setState(() {
            check = !check;
          });
          return;
        }
      }
      setState(() {
        check = !check;
      });
      return;
    }
    formkey.currentState.save();

    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.register( _user ).then((userResponse) async {
      setState(() {
        check = !check;
      });

      Map<String ,dynamic> prepareBody = {
        'idUser': FirebaseAuth.instance.currentUser.uid,
        'firstName': _user.firstname,
        'lastName': _user.lastname,
        'email': _user.email,
        'phoneNumber': _user.phone,
        'photoProfile': 'https://cdn130.picsart.com/329155800062211.png?type=webp&to=min&r=640',
      };

      // if ( _typeAcount ) {
      //   prepareBody["companyName"] = "Jorge company";
      //   prepareBody["country"] = 1;
      //   prepareBody["province"] = 1;
      //   prepareBody["city"] = 1;
      // }

      final url = Uri.parse("http://192.168.1.106:5000/user/user-company");

      // _typeAcount ?   : 'https://hechoencasa-backend.herokuapp.com/user'
      await http.post(url, body: convert.jsonEncode({
        "idUser": "idUsuario222",
        "firstName": "Jrui2z",
        "lastName": "Jaeger",
        "email": "Correo222@gmail.com",
        "phoneNumber": "98899889",
        "photoProfile": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzwKAip4zTU9t-aWwRZuLHFbyRJdKMdsCK9sgiR0APj52jlSZfroKySpcTS27vWdsy57o&usqp=CAU",
        "companyName": "compania",
        "country": 1,
        "province": 2,
        "city": 3
      })).then((value) {
        print('response');
        print(value);
      }).catchError( (error) => print(error));
    });

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
  }
}
