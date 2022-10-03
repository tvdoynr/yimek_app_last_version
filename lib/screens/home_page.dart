import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:yimek_app_lastversion/service/comment_service.dart';
import 'comment_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var data;
  var url = Uri.parse(
      "http://www.sksdb.hacettepe.edu.tr/bidbnew/grid.php?parameters=qbapuL6kmaScnHaup8DEm1B8maqturW8haidnI%2Bsq8F%2FgY1fiZWdnKShq8bTlaOZXq%2BmwWjLzJyPlpmcpbm1kNORopmYXI22tLzHXKmVnZykwafFhImVnZWipbq0f8qRnJ%2BioF6go7%2FOoplWqKSltLa805yVj5agnsGmkNORopmYXam2qbi%2Bo5mqlXRrinJdf1BQUFBXWXVMc39QUA%3D%3D");
  List<String> yemekler = [];

  late String mainYemek;
  final myController = TextEditingController();
  bool comment = true;
  bool isLoaded = false;

  late String _userName;
  late String _userUid;
  CommentService commentService = CommentService();

  String changeTrLetters(String st) {
    st = st.replaceAll(RegExp('Ä±'), 'i');
    st = st.replaceAll(RegExp('Ã'), 'C');
    st = st.replaceAll(RegExp('Ã¼'), 'u');
    st = st.replaceAll(RegExp('Ã§'), 'c');
    st = st.replaceAll(RegExp('Ä'), 'g');
    st = st.replaceAll(RegExp('Å'), 's');
    st = st.replaceAll(RegExp('Ä°'), 'I');
    st = st.replaceAll(RegExp('Ç'), 'C');
    st = st.replaceAll(RegExp('Å'), 'S');
    st = st.replaceAll(RegExp('Ü'), 'U');
    st = st.replaceAll(RegExp('Ã¶'), 'o');
    st = st.replaceAll(RegExp('Ã'), 'U');
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
    //1 -> length-3
  }

  fetch() async {
    final _firebaseUser = await FirebaseAuth.instance.currentUser;

    if (_firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('Person')
          .doc(_firebaseUser.uid)
          .get()
          .then((value) {
        _userName = value.data()!["userName"];
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
                                    child: Flexible(
                                      child: Text(
                                        yemekler[index + 1],
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
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
                              "Yakinda...",
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
                                  children: [
                                    Image(
                                      image:
                                          AssetImage("lib/assets/atatepe.jpg"),
                                    ),
                                    Text(
                                      "Atatepe",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Image(
                                      image:
                                          AssetImage("lib/assets/parlar.jpg"),
                                    ),
                                    Text(
                                      "Parlar",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(height: 15,)
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                color: Colors.red,
              )));
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
