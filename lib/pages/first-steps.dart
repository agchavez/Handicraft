import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:handicraft_app/global/enviroment.dart';
import 'package:handicraft_app/provider/auth_service.dart';
import 'package:provider/provider.dart';

import 'flow_painter.dart';
import 'package:handicraft_app/utils/util.dart';
import 'package:handicraft_app/utils/selectImage.dart';
import 'package:handicraft_app/provider/storage_firebase_service.dart';

class FlowPager extends StatefulWidget {
  @override
  _FlowPageState createState() => _FlowPageState();
}

const items = [
  Color(0xfff50057),
  Color(0xffFFD414),
  Color(0xff41DBBB),
  Color(0xffA6F3FC),
  Color(0xffFFFFFF),
  Color(0xff000000)
];
int currentPage = 0;
bool uploadingImage = false;

class _FlowPageState extends State<FlowPager> {
  ValueNotifier<double> _notifier = ValueNotifier(0.0);
  final _button = GlobalKey();
  final _pageController = PageController();
  File profileImage;
  AuthService auth;
  final dio = Dio();
  FirebaseStorageService firebaseStorage = new FirebaseStorageService();

  @override
  void initState() {
    auth = Provider.of<AuthService>(context, listen: false);
    _pageController.addListener(() {
      _notifier.value = _pageController.page;
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> pages = [
      {"pages": _createPageOne()},
      {"pages": _createPageTwo()},
      {"pages": _createPageTree()},
      {"pages": _createPageFour()},
      {"pages": _createPageFive()},
    ];
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
              animation: _notifier,
              builder: (_, __) => CustomPaint(
                    painter: FlowPainter(
                      context: context,
                      notifier: _notifier,
                      target: _button,
                      colors: items,
                    ),
                  )),
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (c, i) => Container(child: pages[i]['pages']),
          ),
          IgnorePointer(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ClipOval(
                  child: AnimatedBuilder(
                    animation: _notifier,
                    builder: (_, __) {
                      final animatorVal =
                          _notifier.value - _notifier.value.floor();
                      double opacity = 0, iconsPos = 0;
                      int colorIndex;
                      if (animatorVal < 0.5) {
                        opacity = (animatorVal - 0.5) * -2;
                        iconsPos = 80 * -animatorVal;
                        colorIndex = _notifier.value.floor() + 1;
                      } else {
                        colorIndex = _notifier.value.floor() + 2;
                        iconsPos = -80;
                      }

                      if (animatorVal > 0.9) {
                        iconsPos = -250 * (1 - animatorVal) * 10;
                        opacity = (animatorVal - 0.9) * 10;
                      }
                      colorIndex = colorIndex % items.length;
                      currentPage = colorIndex;
                      return SizedBox(
                        key: _button,
                        width: 80,
                        height: 80,
                        child: Transform.translate(
                          offset: Offset(iconsPos, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: items[colorIndex],
                            ),
                            child: Icon(
                              Icons.chevron_right,
                              color: colorIndex == 4
                                  ? Colors.black.withOpacity(opacity)
                                  : Colors.white.withOpacity(opacity),
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPageOne() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: 200,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/images/present-icon.png'),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: RichText(
            text: TextSpan(
              children: [TextSpan(text: "Te damos la bienvenida a Handicraft")],
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy_ExtraBold",
                  fontSize: 35,
                  height: 0.9,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Text(
            "Este es oficialmente nuestro primer contacto contigo, y queremos obsequiarte algunos tips que sabemos te ayudaran.",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    ));
  }

  Widget _createPageTwo() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            String path = await showPicker(context);
            if (path != null) {
              profileImage = await cropImage(path);
              uploadingImage = true;
              setState(() {});
              final uid = await auth.storage.getValue('uid');
              final urlPhotoProfile = await firebaseStorage.uploadImg(profileImage, uid);
              final token = await auth.refreshUserToken();
              Map<String, dynamic> data = {
                "uid": uid,
                "urlPicture": urlPhotoProfile,
              };
              Response response = await dio.put('${Enviroment.ipAddressLocalhost}/user/profile/updateImage',
                  options: Options(headers: {
                    HttpHeaders.contentTypeHeader: "application/json",
                    'token': token
                  }),
                data: jsonEncode(data)
              );
              if ( response.statusCode == 200 ) {
                await auth.storage.setValue(urlPhotoProfile, 'photoProfile');
                uploadingImage = false;
                setState(() {});
              } else {
                uploadingImage = false;
                setState(() {});
              }
            }
          },
          child: profileImage != null
              ? Stack(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: CircleAvatar(
                        backgroundImage: FileImage(profileImage),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                        child: uploadingImage
                            ? Container(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Container(
                                width: 20,
                                height: 20,
                                child:
                                    Image.asset("assets/icons/edit-icon.png"),
                              ),
                      ),
                    )
                  ],
                )
              : Container(
                  height: 200,
                  width: 200,
                  margin: EdgeInsets.only(left: 30),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Image.asset('assets/images/add-picture-2.png'),
                  ),
                ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: RichText(
            text: TextSpan(
              children: [TextSpan(text: "Agrega una fotografia de perfil.")],
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy_ExtraBold",
                  fontSize: 35,
                  height: 1.05,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Text(
            "Puedes agregar una fotografia tocando la imagen de la camara, agregar una fotografia de perfil siempre genera confianza a tus compradores",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    ));
  }

  Widget _createPageTree() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/images/suculenta.png'),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: RichText(
            text: TextSpan(
              children: [TextSpan(text: "Una imagen dice mas que ...")],
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy_ExtraBold",
                  fontSize: 35,
                  height: 1.05,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Text(
            "Se muy selectivo con las fotografias de tu producto, pues estas llamaran la atencion de tus compradores.",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    ));
  }

  Widget _createPageFour() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 220,
          width: 220,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Image.asset('assets/images/hands-fun.png'),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: RichText(
            text: TextSpan(
              children: [TextSpan(text: "Respeta la comunidad")],
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy_ExtraBold",
                  fontSize: 35,
                  height: 1.05,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Text(
            "Handicraft fue creado para comercios de tipo hecho en casa o hecho a mano, asi que no te sorprendas de ser baneado si usas la app para otro fin.",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    ));
  }

  Widget _createPageFive() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 220,
          width: 220,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Image.asset('assets/images/flame-sleepwalking.png'),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: RichText(
            text: TextSpan(
              children: [TextSpan(text: "Hemos finalizado")],
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy_ExtraBold",
                  fontSize: 35,
                  height: 1.05,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.only(left: 35, right: 35),
          child: Text(
            "Esperamos estos consejos sean de mucha ayuda, nosotros seguiremos con nuestras crisis existenciales.",
            style: TextStyle(
                fontFamily: "Montserrat",
                color: Color(0xFFC4C4C4),
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
            padding: EdgeInsets.only(left: 35, right: 35),
            child: RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        text:
                            "Para mas informacion, puede contactarnos a nuestro correo"),
                    TextSpan(
                        text: " handicraft.is.app@gmail.com.",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Color(0xFFC4C4C4),
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            )),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () async {
            final token = await auth.refreshUserToken();
            final uid = await auth.storage.getValue('uid');
            Map<String, dynamic> data = {
              "uid": uid,
              "newStatus": 0,
            };
            Response response = await dio.put('${Enviroment.ipAddressLocalhost}/user/profile/setStatusTips',
                options: Options(headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                  'token': token
                }),
                data: jsonEncode( data )
            );
            if ( response.statusCode == 200 ) {
              Navigator.pushNamed(context, 'home');
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black,
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 14),
              child: Text(
                "Ir a inicio",
                style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
