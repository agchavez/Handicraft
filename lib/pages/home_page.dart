import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/pages/menssange_pages.dart';
import 'package:handicraft_app/pages/newProduct_page.dart';
import 'package:handicraft_app/pages/notification_page.dart';
import 'package:handicraft_app/pages/products_pages.dart';
import 'package:handicraft_app/pages/profile_page.dart';
import 'package:handicraft_app/provider/google_sign_in.dart';
import 'package:handicraft_app/provider/storage_service.dart';
import 'package:provider/provider.dart';

const _cardColor = Color(0xFFFFFF);
const _cardColorExpanded = Color(0X000000);
const _maxHeight = 380.0;
const _minHeigth = 70.0;

class MainExpandableNavBar extends StatefulWidget {
  @override
  _MainExpandableNavBarState createState() => _MainExpandableNavBarState();
}

class _MainExpandableNavBarState extends State<MainExpandableNavBar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _expanded = false;
  double _currentHeight = _minHeigth;
  String uid = "";

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    print(index);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
  }

  _getuid() async {
    uid = await StorageService().getValue("uid");
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getuid();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: uid != ""
          ? Container(
              margin: EdgeInsets.only(bottom: 15),
              width: 50,
              height: 50,
              child: FittedBox(
                child: FloatingActionButton(
                  elevation: 3,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(child: _body(size)),
    );
  }

  Widget pages() {
    switch (_selectedIndex) {
      case 0:
        return ProductsPages();
      case 1:
        return MenssagePages();
      case 2:
        return NotificationPage();
      case 3:
        return PorfilePage();
      case 4:
        return NewpProductPage();
      default:
    }
  }

  Widget _body(size) {
    return Stack(
      children: [
        pages(),
        uid == "" ? createAccountMenu(size) : createNavbar(size)
      ],
    );
  }

  Widget createNavbar(size) {
    return Positioned(
        top: size.height * 0.86,
        child: Container(
          margin:
              EdgeInsets.symmetric(vertical: 5, horizontal: size.width * 0.03),
          child: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            notchMargin: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 53,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        minWidth: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_outlined,
                              color: _selectedIndex == 0
                                  ? Colors.white
                                  : Colors.grey,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        minWidth: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message_outlined,
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: size.width * 0.14,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                        minWidth: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              color: _selectedIndex == 2
                                  ? Colors.white
                                  : Colors.grey,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 3;
                          });
                        },
                        minWidth: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              maxRadius: 18,
                              child: Text('Ag'),
                              backgroundColor: _selectedIndex == 3
                                  ? Colors.white
                                  : Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget createAccountMenu(size) {
    final menuWidth = size.width * 0.8;
    return GestureDetector(
        onVerticalDragUpdate: _expanded
            ? (details) {
                setState(() {
                  final newHeight = _currentHeight - details.delta.dy;
                  _controller.value = _currentHeight / _maxHeight;
                  _currentHeight = newHeight.clamp(_minHeigth, _maxHeight);
                });
              }
            : null,
        onVerticalDragEnd: _expanded
            ? (details) {
                if (_currentHeight < _maxHeight / 2) {
                  _controller.reverse();
                  _expanded = false;
                } else {
                  _expanded = true;
                  _controller.forward(from: _currentHeight / _maxHeight);
                  _currentHeight = _maxHeight;
                }
              }
            : null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, snapshot) {
            final value =
                const ElasticInOutCurve(0.7).transform(_controller.value);
            return Stack(
              children: [
                Positioned(
                  height: lerpDouble(_minHeigth, _currentHeight, value),
                  left: lerpDouble(size.width / 2 - menuWidth / 2, 0, value),
                  width: lerpDouble(menuWidth, size.width, value),
                  bottom: lerpDouble(30.0, 0.0, value),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _expanded ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(
                            lerpDouble(20.0, 0.0, value),
                          )),
                    ),
                    child: _expanded
                        ? Opacity(
                            opacity: _controller.value,
                            child: _buildExpandedContent())
                        : _buildMenuContent(),
                  ),
                ),
              ],
            );
          },
        ));
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, top: 30.0),
                        child: GestureDetector(
                            onTap: () {
                              _controller.reverse();
                              _expanded = false;
                              _currentHeight = _minHeigth;
                            },
                            child: Text(
                              'Saltar',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500),
                            )),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, left: 20.0, bottom: 15.0),
                        child: Text(
                          'Ingresar o crear cuenta.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontFamily: 'Gilroy_ExtraBold',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: RaisedButton(
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.0),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Ingresar',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ])),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                elevation: 2.0,
                                color: Colors.black,
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.popAndPushNamed(context, "login");
                                }),
                          ))
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: RaisedButton(
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/google_icon.png',
                                          width: 15.0,
                                        ),
                                        Text(
                                          '  Ingresa con tu cuenta de Google',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ])),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side:
                                    BorderSide(color: Colors.black, width: 3.0),
                              ),
                              elevation: 2.0,
                              color: Colors.white,
                              textColor: Colors.black,
                              onPressed: () {
                                final provider =
                                    Provider.of<GoogleSignInProvider>(context,
                                        listen: false);
                                provider.googleLogin();
                              },
                            ),
                          ))
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.popAndPushNamed(context, 'register');
                        },
                        child: Text(
                          'Crear Cuenta',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, right: 60.0, left: 60.0, bottom: 10.0),
                    child: Text(
                      'Al hacer clic en Iniciar sesión con Google acepta los términos de uso de Handicraft política de privacidad.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _expanded = true;
                _currentHeight = _maxHeight;
                _controller.forward(from: 0.0);
              });
            },
            child: Text(
              'Unirse a Handicraft',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ))
      ],
    );
  }
}
