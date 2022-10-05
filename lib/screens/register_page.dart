import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yimek_app_lastversion/screens/login_page.dart';
import 'package:yimek_app_lastversion/service/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  var controller3 = TextEditingController();
  var controller4 = TextEditingController();

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
              Image.network(
                "https://upload.wikimedia.org/wikipedia/tr/thumb/2/28/Hacettepe_%C3%9Cniversitesi_Logosu.svg/1200px-Hacettepe_%C3%9Cniversitesi_Logosu.svg.png",
                width: 60,
              ),
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
                        controller: controller1,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: "Kullanıcı Adı",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    Container(
                      width: 280,
                      height: 2,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextField(
                        cursorColor: Colors.white,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                        controller: controller2,
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
                      width: 280,
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
                        controller: controller3,
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
                      width: 280,
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
                        controller: controller4,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: Colors.white,
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: "Parolayı Tekrar Girin",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    Container(
                      width: 280,
                      height: 2,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Container(
                        width: 200,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller3.text.trim() == controller4.text.trim()) {
                              _authService.register(
                                  controller1.text.trim(), controller2.text.trim(),
                                  controller3.text.trim()).then((value) {
                                      return Navigator.pop(context);
                              });
                            }
                            else{
                              Fluttertoast.showToast(
                                  msg: "Parolalar Eşleşmiyor",  // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.CENTER,    // location
                                  timeInSecForIosWeb: 1               // duration
                              );
                            }
                          },
                          child: Text("Kayıt Ol"),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(color: Colors.white))),
                            backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.redAccent;
                                return Colors
                                    .red; // Use the component's default.
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        width: 90,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Geri Dön"),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(color: Colors.white))),
                            backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.redAccent;
                                return Colors
                                    .red; // Use the component's default.
                              },
                            ),
                          ),
                        ),
                      ),
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
