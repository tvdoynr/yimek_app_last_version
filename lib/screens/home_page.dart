import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:yimek_app_lastversion/service/auth.dart';
import 'package:yimek_app_lastversion/service/comment_service.dart';
import 'package:yimek_app_lastversion/service/profile_picture_service.dart';
import 'comment_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var url = Uri.parse(
      "http://www.sksdb.hacettepe.edu.tr/bidbnew/grid.php?parameters=qbapuL6kmaScnHaup8DEm1B8maqturW8haidnI%2Bsq8F%2FgY1fiZWdnKShq8bTlaOZXq%2BmwWjLzJyPlpmcpbm1kNORopmYXI22tLzHXKmVnZykwafFhImVnZWipbq0f8qRnJ%2BioF6go7%2FOoplWqKSltLa805yVj5agnsGmkNORopmYXam2qbi%2Bo5mqlXRrinJdf1BQUFBXWXVMc39QUA%3D%3D");
  List<String> yemekler = [];

  late String mainYemek;
  bool isLoaded = false;
  int _selectedIndex = 0;

  TextEditingController nameController = TextEditingController();

  String _userName = "";
  String _userUid = "";
  String _userPp = "";


  CommentService commentService = CommentService();
  AuthService _auth = AuthService();
  PictureService _pictureService = PictureService();

  String changeTrLetters(String st) {
    st = st.replaceAll(RegExp('Ä±'), 'ı');
    st = st.replaceAll(RegExp('Ã'), 'C');
    st = st.replaceAll(RegExp('Ã¼'), 'ü');
    st = st.replaceAll(RegExp('Ã§'), 'ç');
    st = st.replaceAll(RegExp('Ä'), 'ğ');
    st = st.replaceAll(RegExp('Å'), 'ş');
    st = st.replaceAll(RegExp('Ä°'), 'İ');
    st = st.replaceAll(RegExp('Ç'), 'Ç');
    st = st.replaceAll(RegExp('Å'), 'Ş');
    st = st.replaceAll(RegExp('Ü'), 'Ü');
    st = st.replaceAll(RegExp('Ã¶'), 'ö');
    st = st.replaceAll(RegExp('Ã'), 'Ü');
    return st;
  }

  Future getData() async {
    var res = await http.get(url);
    var body = res.body;
    var parsedBody = parser.parse(body);

    var now = new DateTime.now();
    var formatter = new DateFormat('dd.MM.yyyy');
    String formattedDate = formatter.format(now);

    int yemek_gunu = 0;
    var elements = parsedBody.getElementsByClassName("popular");
    for(int i=0;i<elements.length;i++){
      String date = elements[i].text.split(" ")[1];
      if(date.split(".")[0].length == 1){
        date = "0" + date.split(".")[0] + "." + date.split(".")[1] + "." + date.split(".")[2];
      }
      if (date == formattedDate) {
      print(date);
      if(date == formattedDate){
        yemek_gunu = i;
      }
    }

    var yemeklerString =
        parsedBody.getElementsByTagName("P")[yemek_gunu].innerHtml.split("<br>");
    setState(() {
      for (int i = 0; i < yemeklerString.length - 1; i++) {
        yemekler.add(changeTrLetters(yemeklerString[i]));
      }
      mainYemek = yemekler[1];
    });

    setState(() {
      isLoaded = true;
    });
  }

  fetch() async {
    final _firebaseUser = await FirebaseAuth.instance.currentUser;

    if (_firebaseUser != null) {
      if (_firebaseUser.isAnonymous) {
        _userUid = _firebaseUser.uid;
        _userName = "Anonim";
      }
      await FirebaseFirestore.instance
          .collection('Person')
          .doc(_firebaseUser.uid)
          .get()
          .then((value) {
        _userName = value.data()!["userName"];
        _userPp = value.data()!["pictureLink"];
        _userUid = _firebaseUser.uid;

      });
    }
  }

  @override
  void initState() {
    fetch();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: !isLoaded
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : _selectedIndex == 0
              ? SafeArea(
                  child: Center(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Günün Menüsü",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          width: 360,
                          height: 1.5,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: yemekler.length - 2,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Container(
                                      width: 200,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            mainYemek = yemekler[index + 1];
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentPage(
                                                          mainYemek: mainYemek,
                                                          userName: _userName,
                                                          userUid: _userUid)));
                                        },
                                        child: Text(
                                          yemekler[index + 1],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: isLoaded
            ? SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: const Text(
                        "Gunun Menusu",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(color: Colors.black,width: 360,height: 1.5,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: yemekler.length - 2,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Container(
                                  width: 200,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        mainYemek = yemekler[index + 1];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentPage(
                                                        mainYemek: mainYemek,
                                                        userName: _userName,
                                                        userUid: _userUid)));
                                      });
                                    },
                                      child: Text(
                                        yemekler[index + 1],
                                        style: const TextStyle(
                                          fontSize: 20, color: Colors.white
                                        ),
                                      )
                                    /*child: Flexible(
                                      child: Text(
                                        yemekler[index + 1],
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    )*/,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Container(color: Colors.black,width: 360,height: 1.5,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Yakında...",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Container(
                                color: Colors.black,
                                width: 360,
                                height: 1.5,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Yakında...",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: const [
                                        Image(
                                          image: AssetImage(
                                              "lib/assets/atatepe.jpg"),
                                        ),
                                        Text(
                                          "Atatepe",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: const [
                                        Image(
                                          image: AssetImage(
                                              "lib/assets/parlar.jpg"),
                                        ),
                                        Text(
                                          "Parlar",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _userName == "Anonim"
                            ? Container(
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 150,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _userPp != ""
                                      ? Image(image: NetworkImage(_userPp),width: 150,height: 150,fit:BoxFit.cover)
                                      : Container(
                                          color: Colors.grey,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 150,
                                          ),
                                        ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                        'Profil Fotoğrafını Değiştir'),
                                                    actions: <Widget>[
                                                      Row(
                                                        children: [
                                                          MaterialButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              this.setState(
                                                                  () {
                                                                _userPp=
                                                                     _pictureService
                                                                        .getPhotoFromGallery() as String;
                                                              });
                                                            },
                                                            child: Text(
                                                              "Galeriden Seç",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            enableFeedback:
                                                                false,
                                                          ),
                                                          MaterialButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              this.setState(
                                                                  () {
                                                                _userPp =
                                                                     _pictureService
                                                                        .getPhotoFromCam() as String;
                                                              });
                                                            },
                                                            child: Text(
                                                              "Fotoğraf Çek",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            enableFeedback:
                                                                false,
                                                          ),
                                                          MaterialButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "İptal",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            enableFeedback:
                                                                false,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: 175,
                              height: 2,
                              color: Colors.black,
                            )),
                        _userName != "Anonim"
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _userName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                        'Kullanıcı Adını Değiştir'),
                                                    actions: <Widget>[
                                                      Column(
                                                        children: [
                                                          TextField(
                                                            cursorColor:
                                                                Colors.black,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                            controller:
                                                                nameController,
                                                            decoration:
                                                                const InputDecoration(
                                                              prefixIcon: Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  "Yeni kullanıcı adını giriniz",
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 250,
                                                            height: 2,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.8),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Spacer(),
                                                          MaterialButton(
                                                            onPressed: () {
                                                              this.setState(() {
                                                                _userName =
                                                                    nameController
                                                                        .text;
                                                              });
                                                              _auth.updateUserName(
                                                                  nameController
                                                                      .text,
                                                                  _userUid);
                                                              nameController
                                                                  .clear();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "Kaydet",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            enableFeedback:
                                                                false,
                                                          ),
                                                          MaterialButton(
                                                            onPressed: () {
                                                              nameController
                                                                  .clear();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "İptal",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            enableFeedback:
                                                                false,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                _userName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                ),
                              ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: 175,
                              height: 2,
                              color: Colors.black,
                            )),
                        ElevatedButton(
                          onPressed: () {
                            _auth.signOut();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              fixedSize: Size(150, 20)),
                          child: Text("Çıkış Yap"),
                        )
                      ],
                    ),
                  ),
                          SizedBox(height: 15,)
                        ],
                      ),
                    )
                  ],
                ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.15),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 26,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[200]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Ana Sayfa',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Ayarlar',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRoute(String mainYemek, String userName, String userUid) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CommentPage(mainYemek: mainYemek, userName: userName, userUid: userUid),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
