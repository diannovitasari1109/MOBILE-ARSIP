

import 'package:arsipdian2/screens/home_screen.dart';
import 'package:arsipdian2/screens/login_screen.dart';
import 'package:arsipdian2/screens/register.dart';
import 'package:arsipdian2/secondpage.dart';
import 'package:arsipdian2/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}


class _FirstPageState extends State<FirstPage> {

  final storage = new FlutterSecureStorage();
  bool authBool = false;
  var tooken;


  void readToken() async {
    String? token = await storage.read(key: 'token');
    tooken = token;
    Provider.of<Auth>(context, listen: false).tryToken(token: token!);
    print(token);
    if(token == null) {
      authBool = false;
      print("token null");
    }else{
      authBool = true;
      print("token tidak null");
    }
    print(authBool);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readToken();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        //height: MediaQuery.of(context).size.height*0.8,
        decoration: BoxDecoration(
          color: Colors.white

        ),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            SizedBox(height: 40,),
            Padding(
                padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Mobile Notary",
                  style: TextStyle(color: Colors.blue,fontSize: 40,fontWeight: FontWeight.w600),
                  ),

                  SizedBox(height: 30,),

                  Container(
                    height: MediaQuery.of(context).size.height*0.38,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                        )
                      ]
                    ),
                    child: Image.asset('assets/image/notaryfirstpage.jpeg',
                    ),
                  ),

                  SizedBox(height: 20,)

                ],
              ),

            ),

            Expanded(
                child:Container(
                  width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(140)),
                  color: Colors.blue
                ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200.0,
                        height: 50.0,
                        child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));

                            },
                            child:
                            Text('Daftar',style: TextStyle(fontSize: 25,color: Colors.blue,fontWeight: FontWeight.w600),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white)
                                  )
                              )
                          ),
                        ),
                      ),

                      SizedBox(height: 20,),


                      SizedBox(
                        width: 200.0,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: (){

                            if (tooken == null){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                            }else if (tooken != null){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondPage()));
                            }

                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                          },
                          child:
                          Text('Masuk',style: TextStyle(fontSize: 25,color: Colors.blue,fontWeight: FontWeight.w600),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white)
                                  )
                              )
                          ),
                        ),
                      ),





                    ],
                  ),
                  

                )
            ),

          ],
        ),
      ),
    );
  }
}
