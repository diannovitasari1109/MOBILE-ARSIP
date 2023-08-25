

import 'dart:io';

import 'package:arsipdian2/first_page.dart';
import 'package:arsipdian2/input/addData.dart';
import 'package:arsipdian2/mainpage/mainlist.dart';
import 'package:arsipdian2/percobaan4.dart';
import 'package:arsipdian2/screens/home_screen.dart';
import 'package:arsipdian2/screens/login_screen.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';
import '../services/dio.dart';
import '/mainpage/mainlist_detail.dart';

class SecondPage extends StatefulWidget {
  //const mainList({Key? key}) : super(key: key);

  late String idx;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  final storage = new FlutterSecureStorage();
  late String token2;

  late List jsonList;
  bool isDataLoaded = false;
  bool authBool = false;

  List<dynamic> jsonListConvert = [];

  TextEditingController _tanggal = TextEditingController();
  TextEditingController _tanggal2 = TextEditingController();

  /*void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token!);
    print(token);
  }*/
  //Map<String, String> data = {"start_date":"","end_date":""};

  //DIOOOO
  void getData() async {
    try {
      /*var response = await Dio()
          .get('http://10.0.2.2/arsipdian/public/api/posts');
*/

      ////////////////////////////////sing 2
      String? token = await storage.read(key: 'token');
      Provider.of<Auth>(context, listen: false).tryToken(token: token!);
      print(token);
      token2 = token;
      authBool =true;
      print(authBool);

      /*FormData data = FormData.fromMap({
        "start_date" : "2023-05-01",
        "end_date" : "2023-06-10",
        'atas_nama': _tanggal.text,
        'keterangan': _tanggal2.text,
      });*/






      Dio.Response response = await dio().get('/posts',
        //data: data,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if(response.statusCode == 200){
        setState(() {
          jsonList = response.data['data'] as List;
          //print(jsonList.length);
          isDataLoaded = true;

          jsonListConvert = jsonList;
          //print(jsonListConvert);
        });
      }else{
        print(response.statusCode);
      }




      //print(response);
    } catch (e) {
      print(e);
    }
  }





  @override
  void initState(){
    getData();
  }

  _runFilter(String enteredKeyword) {
    List<dynamic> results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = jsonList;
    } else {
      results = jsonListConvert
          .where((user) =>
          user["atas_nama"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive

    }
    setState(() {
      jsonListConvert = results;
    });
  }


  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _key,
      //appBar: AppBar(title: Text("Searching Data"),centerTitle: true,),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>addData()));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),

      ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 210,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          //height: 240,
                          height: 180,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)
                              )
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                child:
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: (){
                                            //Navigator.of(context).pop(MaterialPageRoute(builder: (context)=> HomeScreen()));
                                            _key.currentState!.openDrawer();

                                          },
                                          icon: Icon(Icons.power_settings_new,size: 30,color: Colors.white,)

                                      ),
                                      /*IconButton(
                                          onPressed: () => _key.currentState!.openDrawer(),
                                          icon: Icon(Icons.menu,size: 30,color: Colors.white,)

                                      ),*/
                                      SizedBox(width: 20,),
                                      Spacer(),
                                      IconButton(
                                          onPressed: (){

                                            if (authBool==true){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>mainList()));
                                            }else if (authBool==false){
                                            _key.currentState!.openDrawer();
                                            }

                                          },
                                          icon: Icon(Icons.filter_alt,size: 30,color: Colors.white,)

                                      ),

                                      IconButton(
                                          onPressed: (){
                                            //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> percobaan4()));
                                            if (authBool==true){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>percobaan4()));
                                            }else if (authBool==false){
                                              _key.currentState!.openDrawer();
                                            }


                                          },
                                          icon: Icon(Icons.qr_code_scanner_sharp,size: 30,color: Colors.white,)

                                      ),



                                    ],
                                  )
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 60,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text("Selamat Datang, Staff",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),





                                ],
                              ),



                            ],

                          ),

                        ),



                      ],
                    ),
                    Positioned(
                      top: 150,
                      left: MediaQuery.of(context).size.width*0.11,
                      child: Container(
                        //height: 100,
                        //width: 320,
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black87),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: TextFormField(
                          onChanged: (value) => _runFilter(value),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Ketikan Sesuatu Disini",
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5)
                              ),
                              prefixIcon: Icon(
                                  Icons.search
                              )
                          ),
                        ),
                      ),
                    ),



                  ],
                ),
              ),

              !isDataLoaded ? Center(child: Column(
                children: [
                  SizedBox(height: 150,),
                  CircularProgressIndicator(),
                ],
              ),)

                  :Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10,left: 10,top: 10),
                  child: ListView.builder(
                      itemCount: jsonListConvert == null ? 0 : jsonListConvert.length,
                      itemBuilder: (BuildContext context,int index ){
                        return Card(
                          color: Colors.blue,
                          child: ListTile(
                            onTap:() {
                              print(jsonListConvert[index]);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainListDetail(idx: jsonList[index],)));},
                            title: Text(jsonListConvert[index]['atas_nama']
                              ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(jsonListConvert[index]['tanggal_pembuatan'],
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600)
                            ),
                            trailing: Container(
                              width: 30,
                              child: Row(
                                children: [
                                  Expanded(child: IconButton(
                                      onPressed: (){
                                        String pilihan = jsonListConvert[index]['atas_nama'];
                                        showDialog(
                                            context: context,
                                            builder: (context)=>AlertDialog(
                                              title: Text("Yakin kah kamu?"),
                                              content: Text("Apakah kamu yakin ingin menghapus data berkas atas nama $pilihan ?"),
                                              actions: [
                                                TextButton(onPressed: () async {

                                                  var pilihanid = jsonListConvert[index]['id'];
                                                  print(pilihanid.toString());

                                                  /*Dio.Response response = await dio().delete('/posts/$pilihanid',
                                                  options: Dio.Options(headers: {'Authorization': 'Bearer $token2'}),
                                                );*/

                                                  Dio.Response response = await dio().post('/hapus/$pilihanid',
                                                    options: Dio.Options(headers: {'Authorization': 'Bearer $token2'}),
                                                  );

                                                  setState(() {
                                                    getData();
                                                  });
                                                  print(response);


                                                  Navigator.of(context, rootNavigator: true).pop('dialog');

                                                }, child: Text("Ya")),
                                                TextButton(onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog')
                                                    , child: Text("Tidak")),
                                              ],
                                            )


                                        );
                                      },
                                      icon: Icon(Icons.delete,color: Colors.white,))),

                                ],
                              ),
                            ),
                          ),);
                      }),
                ),
              )


            ],
          ),
        ),


      drawer: Drawer(
        child: Consumer<Auth>(builder: (context, auth,child){
          if (! auth.authenticated){
            return ListView(
              children: [
                ListTile(
                  title: Text("Login"),
                  leading: Icon(Icons.login),
                  onTap: () async{

                    authBool = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
                    //Navigator.of(context).pop(MaterialPageRoute(builder: (context)=> LoginScreen()));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height/3,),
                Center(child: Text("Harap Login Dulu", style: TextStyle(
                    fontSize: 22,fontWeight: FontWeight.w600
                ),))
              ],
            );
          }
          else if( auth.authenticated && auth.user?.username == null ){
            return const Center(
                child: CircularProgressIndicator()
            );
          }
          else{
            return ListView(
              children: [
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Image.asset("assets/image/logoad.png"
                        ,width: 50,height: 50,
                      ),
                      /*CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                      ),*/
                      SizedBox(height: 10,),
                      Text(auth.user!.username.toString(),style: TextStyle(color: Colors.white),)
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))
                  ),
                ),

                ListTile(
                  title: Text("Logout"),
                  leading: Icon(Icons.logout,color: Colors.blue,),
                  onTap: (){

                    _showDialog(context);


                    //Provider.of<Auth>(context, listen: false)
                    //    .logout();
                    //authBool = false;



                  },
                )
              ],
            );
          }

        }),
      ),






    );

  }


  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Log Out!!"),
          content: new Text("Apakah anda yakin akan log out??"),
          actions: <Widget>[
            new TextButton(
              child: new Text("OK"),
              onPressed: () {
                //Navigator.of(context).pop();

                Provider.of<Auth>(context, listen: false)
                    .logout();

                Navigator.of(context).pop();

                setState(() {
                authBool = false;
                isDataLoaded = false;
                });


              },
            ),
            new TextButton(
              child: new Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),

          ],
        );
      },
    );
  }


}

