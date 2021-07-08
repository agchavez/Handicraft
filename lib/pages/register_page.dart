import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/models/acount_user.dart';
import 'package:path_provider/path_provider.dart';

import 'package:handicraft_app/utils/util.dart' as utils;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

final formkey = GlobalKey<FormState>();
final form2key = GlobalKey<FormState>();
File? foto, newImage;
bool _typeAcount = false, _showpasword = true, check = false;
UserAcountModel user = new UserAcountModel();

class _RegisterPageState extends State<RegisterPage> {
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
            _createImg(context),
            _createForm(),
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
              height: 20,
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
                    Text("you already have an account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16)),
                    Text(
                      " Login",
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
              child: Text(
                """By clicking log in or continue with google, 
you accept Handicraft's terms of use and 
privacy policy. 
            """,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createLog() {
    return Column(
      children: [
        Image(height: size.height * 0.08, image: AssetImage('assets/logo.png')),
        Text(
          "Products that you will love.",
          style: TextStyle(color: Colors.grey[600], fontSize: 15),
        )
      ],
    );
  }

  Widget _createImg(BuildContext context) {
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
                placeholder: AssetImage("assets/Spinner-1s-200px.gif"),
                image: _mostrarFoto(""))),
      ),
    );
  }

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
            ],
          )),
    );
  }

  Widget _createName() {
    return Container(
        width: size.width * 0.7,
        height: size.height * 0.085,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
            style: TextStyle(decorationColor: Colors.white),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 100, color: Colors.white10),
                  borderRadius: BorderRadius.circular(7.0)),
              hintText: 'Name',
            ),
            onSaved: (value) => user.firstname = value,
            validator: (value) {
              if (value!.isEmpty || utils.isNumeric(value)) {
                return 'Campo obligatorio';
              } else {
                return null;
              }
            }));
  }

  Widget _createLastName() {
    return Container(
        width: size.width * 0.7,
        height: size.height * 0.085,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
                borderRadius: BorderRadius.circular(7.0)),
            hintText: 'Last name',
          ),
          onSaved: (value) => user.lastname = value,
          validator: (value) {
            if (value!.isEmpty || utils.isNumeric(value)) {
              return 'Campo obligatorio';
            } else {
              return null;
            }
          },
        ));
  }

  Widget _createEmail() {
    return Container(
        width: size.width * 0.7,
        height: size.height * 0.085,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
                borderRadius: BorderRadius.circular(7.0)),
            hintText: 'Email',
          ),
          onSaved: (value) => {user.email = value.toString(), print("object")},
          validator: (value) {
            if (!utils.validatorEmail(value.toString())) {
              return 'Correo no valido';
            } else {
              return null;
            }
          },
        ));
  }

  Widget _createPassword() {
    return Container(
        width: size.width * 0.7,
        height: size.height * 0.085,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          obscureText: _showpasword,
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
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
                borderRadius: BorderRadius.circular(7.0)),
            hintText: 'Password',
          ),
          onSaved: (value1) => user.password = value1,
          validator: (value) {
            if (value!.isEmpty) {
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
            "Company",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            width: 15,
          ),
          CupertinoSwitch(
            activeColor: Colors.black,
            value: _typeAcount,
            onChanged: (bool value) {
              setState(() {
                _typeAcount = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _createBottom(BuildContext context) {
    return RaisedButton(
      child: Container(
          width: size.width * 0.6,
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Registrarse'),
              ])),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      elevation: 2.0,
      color: Colors.black,
      textColor: Colors.white,
      onPressed: () => _createAcount(),
    );
  }

  Widget _createFormCompanies() {
    return Container(
      child: Form(
          key: form2key,
          child: Column(
            children: [_createNameCompanie()],
          )),
    );
  }

  Widget _createNameCompanie() {
    return Container(
        width: size.width * 0.7,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
            style: TextStyle(decorationColor: Colors.white),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 100, color: Colors.white10),
                  borderRadius: BorderRadius.circular(7.0)),
              hintText: 'Name company',
            )));
  }

  _createAcount() {
    setState(() {
      check = !check;
    });
    if (!formkey.currentState!.validate()) {
      setState(() {
        check = !check;
      });
      return;
    }
    formkey.currentState!.save();
    setState(() {
      check = !check;
    });
  }

  _mostrarFoto(data) {
    if (data == '' || data.fotoUrl == null) {
      return AssetImage('assets/unnamed.png');
    } else {
      return NetworkImage(
        data.fotoUrl,
      );
    }
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // // Navigator.pop on the Selection Screen.
    Directory tempDir = await getApplicationDocumentsDirectory();
    print(tempDir);
    String tempPath = tempDir.path;
  }
}
