//import "dart:js";

import "dart:io";

import "package:arsipdian2/models/user.dart";
import "package:arsipdian2/services/dio.dart";
import "package:dio/dio.dart" as Dio;
import "package:flutter/material.dart";
import "package:flutter_flushbar/flutter_flushbar.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:fluttertoast/fluttertoast.dart";



class Auth extends ChangeNotifier{
  bool _isLoggedIn = false;
  User? _user;
  String? _token;

  bool get authenticated => _isLoggedIn;
  User? get user => _user;

  final storage = new FlutterSecureStorage();

  /////////////////////////

  final GlobalKey<ScaffoldMessengerState> snackbarKey =
  GlobalKey<ScaffoldMessengerState>();

  ///////////////////////////

  void login({required Map creds}) async {
    print(creds);

    try {
        Dio.Response response = await dio().post('/login', data: creds);
        print(response.data.toString());

        String token = response.data.toString();
        this.tryToken(token: token);

        _isLoggedIn = true;

        notifyListeners();

        Fluttertoast.showToast(
            msg: "Login Berhasil",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );


    }catch(e){
      print(e);

      Fluttertoast.showToast(
          msg: "Login Gagal",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }


  }

  void tryToken({required String token}) async {
    if (token == null){
      return;
    }else{
      try {
        Dio.Response response = await dio().get('/me', options: Dio.Options(headers: {'Authorization' : 'Bearer $token'}));
        this._isLoggedIn = true;
        this._user = User.fromJson(response.data);
        this._token = token;
        this.storeToken(token: token);

        notifyListeners();
        print(_user);
      }catch(e){
        print(e);
      }
    }
  }

  void storeToken({required String token}) async {
      this.storage.write(key: 'token', value: token);
  }
  void logout() async {

    try {
      Dio.Response response = await dio().post('/logout',
      options: Dio.Options(headers: {'Authorization' : 'Bearer $_token'}));
      cleanUp();
      notifyListeners();

    }catch(e){
      print(e);
    }

  }

  void cleanUp() async {
    this._user = null;
    this._isLoggedIn = false;
    this._token = null;

    await storage.delete(key: 'token');

  }

  ////////////////////////////Create Post
  void buat({required Map creds}) async {
    print(creds);

    try {
      Dio.Response response = await dio().post('/posts', data: creds,options: Dio.Options(headers: {'Authorization' : 'Bearer $_token'}));


      print(response.data.toString());

      //String token = response.data.toString();
      //this.tryToken(token: token);

      //_isLoggedIn = true;

      //notifyListeners();
    }catch(e){
      print(e);
    }
  }

  void register({required Map creds}) async {
    print(creds);

    try {
      Dio.Response response = await dio().post('/register', data: creds);
      print(response.data.toString());

      String token = response.data.toString();
      Fluttertoast.showToast(msg: "Akun berhasil dibuat");

    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: "Tidak berhasil dibuat error : $e");
    }



  }

  void hapus({required id}) async {
    print(id);

    try {
      Dio.Response response = await dio().delete('/posts/$id');
      print(response.data.toString());

      String token = response.data.toString();

    }catch(e){
      print(e);
    }


  }

  /*showPrintedMessage(String title, String msg) {
    Flushbar(
      title: title,
      message: msg,
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.info,
        color: Colors.blue,
      ),
    )..show(context );
  }*/

}