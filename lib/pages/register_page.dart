import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/acount_user.dart';
import 'package:custom_switch_button/custom_switch_button.dart';

import 'package:handicraft_app/utils/util.dart' as utils;
import 'package:handicraft_app/widgets/image.dart';
//import 'package:handicraft_app/widgets/image.dart' as imageWid;

// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

final formkey = GlobalKey<FormState>();
final form2key = GlobalKey<FormState>();
File foto, newImage;
bool _typeAcount = false, _showpasword = true, check = false;
UserAcountModel user = new UserAcountModel();
String _countryValue = 'ciudad', _stateValue = '';

class _RegisterPageState extends State<RegisterPage> {
  final picker = ImagePicker();
  Size size = Size(1000, 5000);
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.14,
            ),
            _createLog(),
            SizedBox(
              height: 10,
            ),
            //_createImg(context),
            //SizedBox(
            //height: 10,
            //),
            /* */

            Center(
              child: GestureDetector(
                onTap: () {
                  showPicker(context);
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.black,
                  child: tempimageFileList != null
                      ? previewImages()
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
            ),
            /* */
            SizedBox(
              height: 10,
            ),
            _createForm(),
            SizedBox(
              height: 10,
            ),
            _createSelect(),
            SizedBox(
              height: 10,
            ),
            if (_typeAcount) _createFormCompanies(),
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
                    Text("ya tienes una cuenta?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16)),
                    Text(
                      " Iniciar Sesión",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                """Al hacer clic en iniciar sesión o continuar con google,
            acepta los términos de uso de Handicraft y
            política de privacidad. 
            """,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
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
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
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

  Widget _createLog() {
    return Column(
      children: [
        Image(
          height: size.height * 0.07,
          image: AssetImage('assets/images/logo.png'),
        ),
        Text(
          "Products that you will love.",
          style: TextStyle(color: Colors.grey[600], fontSize: 15),
        )
      ],
    );
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
        width: size.width * 0.65,
        padding: EdgeInsets.symmetric(vertical: 0.0),
        child: TextFormField(
            scrollPadding: EdgeInsets.symmetric(vertical: 0.0),
            style: TextStyle(decorationColor: Colors.white),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.black,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 100, color: Colors.white10),
                  borderRadius: BorderRadius.circular(10.0)),
              hintText: 'Nombre',
            ),
            onSaved: (value) => user.firstname = value,
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
        width: size.width * 0.65,
        child: TextFormField(
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.white10),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Apellido',
          ),
          onSaved: (value) => user.lastname = value,
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
        width: size.width * 0.65,
        child: TextFormField(
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Correo electrónico',
          ),
          onSaved: (value) => {user.email = value.toString(), print("object")},
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
        width: size.width * 0.65,
        child: TextFormField(
          obscureText: _showpasword,
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 1.5,
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
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: 'Contraseña',
          ),
          onSaved: (value1) => user.password = value1,
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
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.18),
      child: Row(
        children: [
          Text(
            "Empresa",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            width: 15,
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
                  borderRadius: BorderRadius.circular(10)),
              child: CustomSwitchButton(
                backgroundColor: Colors.white10,
                unCheckedColor: Colors.black,
                animationDuration: Duration(milliseconds: 400),
                checkedColor: Colors.black,
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
      width: size.width * 0.65,
      child: RaisedButton(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Registrarme'),
                ])),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        color: Colors.black,
        textColor: Colors.white,
        onPressed: () => _createAcount(),
      ),
    );
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
              _createState()
            ],
          )),
    );
  }

  Widget _createNameCompanie() {
    return Container(
        width: size.width * 0.65,
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
                  width: 1.5,
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.black,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 100, color: Colors.white10),
                  borderRadius: BorderRadius.circular(10.0)),
              hintText: 'Name company',
            )));
  }

  Widget _createPhoneNumber() {
    return Container(
        width: size.width * 0.65,
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
                  width: 1.5,
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.black,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 100, color: Colors.white10),
                  borderRadius: BorderRadius.circular(10.0)),
              hintText: 'Numero de telefono',
            )));
  }

  Widget _createCountry() {
    return Container(
      width: size.width * 0.65,
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.5, color: Colors.black)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: DropdownButton<String>(
                value: _countryValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 42,
                underline: SizedBox(
                  width: 30,
                ),
                onChanged: (newValue) {
                  setState(() {
                    _countryValue = newValue.toString();
                  });
                },
                items: <String>[
                  'ciudad',
                  'La Paz',
                  'Francisco Morazan',
                  'Cortes',
                  'Four'
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
      width: size.width * 0.65,
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.5, color: Colors.black)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Departamento"),
          DropdownButton<String>(
              value: _stateValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 42,
              underline: SizedBox(
                width: 30,
              ),
              onChanged: (newValue) {
                setState(() {
                  _stateValue = newValue.toString();
                });
              },
              items: <String>['', 'La Paz', 'Marcala', 'Guajiquiro', 'Tutule']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()),
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
}
