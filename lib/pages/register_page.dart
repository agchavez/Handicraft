import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

final formkey = GlobalKey<FormState>();
bool _typeAcount = false;

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
            _createForm(),
            _createSelect(),
            SizedBox(
              height: 10,
            ),
            _createBottom(context),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: size.height * 0.15),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'home');
                },
                child: Container(
                    child: Row(
                  children: [
                    Text("No account?", style: TextStyle(fontSize: 16)),
                    Text(
                      " Create One",
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
        Image(height: size.height * 0.12, image: AssetImage('assets/logo.png')),
        Text(
          "Products that you will love.",
          style: TextStyle(color: Colors.grey[600], fontSize: 15),
        )
      ],
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
              if (_typeAcount) _createPassword()
            ],
          )),
    );
  }

  Widget _createName() {
    String nombres;
    return Container(
        width: size.width * 0.8,
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
        width: size.width * 0.8,
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
        width: size.width * 0.8,
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
        width: size.width * 0.8,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          style: TextStyle(decorationColor: Colors.white),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 100, color: Colors.white10),
                borderRadius: BorderRadius.circular(7.0)),
            hintText: 'Password',
          ),
          onSaved: (value1) => nombres = value1.toString(),
        ));
  }

  Widget _createSelect() {
    return MergeSemantics(
      child: ListTile(
        horizontalTitleGap: 10.0,
        title: const Text('Compañia'),
        trailing: CupertinoSwitch(
          activeColor: Colors.black,
          value: _typeAcount,
          onChanged: (bool value) {
            setState(() {
              _typeAcount = value;
            });
          },
        ),
        onTap: () {
          setState(() {
            _typeAcount = !_typeAcount;
          });
        },
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
}
