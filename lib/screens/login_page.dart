import 'package:flutter/material.dart';
import 'package:yimek_app_lastversion/main.dart';
import 'package:yimek_app_lastversion/screens/register_page.dart';
import 'package:yimek_app_lastversion/service/auth.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var myController1 = TextEditingController();
  var myController2 = TextEditingController();

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(image: AssetImage("lib/assets/hacettepe.png"),width: 70,),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey, blurRadius: 20, spreadRadius: 2)
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: TextField(
                        cursorColor: Colors.white,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                        controller: myController1,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: "E-mail",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 2,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                        controller: myController2,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: "Parola",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 2,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          _authService
                              .signIn(myController1.text.trim(), myController2.text.trim())
                              .then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home())));
                        },
                        child: Text("Giriş Yap"),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(color: Colors.white))),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.redAccent;
                              return Colors.red; // Use the component's default.
                            },
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Hesabın yok mu?",
                          style: TextStyle(color: Colors.white),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                          child: Text(
                            "Kayıt Ol",
                            style: TextStyle(color: Colors.white),
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          enableFeedback: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
