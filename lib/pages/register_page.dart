import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

final formkey = GlobalKey<FormState>();
final form2key = GlobalKey<FormState>();
bool _typeAcount = false, _showpasword = true;

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
            SizedBox(
              height: size.height * 0.05,
            ),
            _createImg(),
            _createForm(),
            _createSelect(),
            SizedBox(
              height: 10,
            ),
            if (_typeAcount) _createFormCompanies(),
            SizedBox(
              height: 20,
            ),
            _createBottom(context),
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

  Widget _createImg() {
    return Container(
      width: size.width * 0.3,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(90),
          child: FadeInImage(
              height: 120,
              width: 140,
              fit: BoxFit.fitHeight,
              placeholder: AssetImage("assets/Spinner-1s-200px.gif"),
              image: _mostrarFoto(""))),
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
    String nombres;
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
            hintText: 'Name',
          ),
          onSaved: (value1) => nombres = value1.toString(),
        ));
  }

  Widget _createLastName() {
    String nombres;
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
            hintText: 'Last name',
          ),
          onSaved: (value1) => nombres = value1.toString(),
        ));
  }

  Widget _createEmail() {
    String nombres;
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
            hintText: 'Email',
          ),
          onSaved: (value1) => nombres = value1.toString(),
        ));
  }

  Widget _createPassword() {
    String nombres;
    return Container(
        width: size.width * 0.7,
        height: 50,
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
          onSaved: (value1) => nombres = value1.toString(),
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
      onPressed: () => print("login"),
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

  _mostrarFoto(data) {
    if (data == '' || data.fotoUrl == null) {
      return AssetImage('assets/unnamed.png');
    } else {
      return NetworkImage(
        data.fotoUrl,
      );
    }
  }
}
