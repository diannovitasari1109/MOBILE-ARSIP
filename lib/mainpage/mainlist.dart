

import 'package:arsipdian2/screens/home_screen.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';
import '../services/dio.dart';
import 'mainlist_detail.dart';

class mainList extends StatefulWidget {
  //const mainList({Key? key}) : super(key: key);

  late String idx;

  @override
  State<mainList> createState() => _mainListState();
}

class _mainListState extends State<mainList>
with SingleTickerProviderStateMixin {

  late TabController tabController;

  final storage = new FlutterSecureStorage();
  late String token2;

  late List jsonList;
  bool isDataLoaded = false;
  List<dynamic> jsonListConvert = [];

  TextEditingController _tanggal = TextEditingController();
  TextEditingController _tanggal2 = TextEditingController();

  /*void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token!);
    print(token);
  }*/

  //Map<String, String> data = {"start_date":"","end_date":"","surat":"masuk"};
  Map<String, String> data = {"surat":"masuk"};

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

      /*FormData data = FormData.fromMap({
        "start_date" : "2023-05-01",
        "end_date" : "2023-06-10",
        'atas_nama': _tanggal.text,
        'keterangan': _tanggal2.text,
      });*/






      Dio.Response response = await dio().get('/filter',
          data: data,
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}),
          );

      if(response.statusCode == 200){
        setState(() {
          jsonList = response.data['data'] as List;
          print(jsonList);
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
    tabController = TabController(length: 3,vsync: this);
  }

  _runFilter(String enteredKeyword) {
  List<dynamic> results = [];

  if (enteredKeyword.isEmpty) {
  // if the search field is empty or only contains white-space, we'll display all users
  results = jsonList;
  } else {
  results = jsonListConvert
      .where((user) =>
      (user["atas_nama"].toLowerCase().contains(enteredKeyword.toLowerCase())) ||
      (user["keterangan"].toLowerCase().contains(enteredKeyword.toLowerCase())))
      .toList();
  // we use the toLowerCase() method to make it case-insensitive

  }
  setState(() {
    jsonListConvert = results;
  });
  }

  @override
  void dispose() {
    tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //appBar: AppBar(title: Text("Searching Data"),centerTitle: true,),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        //height: 240,
                        //height: 220,
                        height: 150,
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
                                child: IconButton(
                                    onPressed: (){
                                      Navigator.of(context).pop(MaterialPageRoute(builder: (context)=> HomeScreen()));
                                    },
                                    icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,)

                                ),
                            ),
                            Column(
                              children: [
                                SizedBox(height: 35,),
                                /*Center(
                                  child: Text("Masukan Rentang Tanggal Pembuatan Akta",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),*/

                                /*Padding(
                                  padding: const EdgeInsets.only(top: 10,bottom: 8,right: 8,left: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                            style: TextStyle(color: Colors.white),
                                            readOnly: true,
                                            decoration: new InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white),
                                                ),
                                                prefixIcon: Icon(Icons.calendar_today,color: Colors.white,),
                                                labelText: "Awal",
                                                labelStyle: TextStyle(
                                                  color: Colors.white, //<-- SEE HERE
                                                ),
                                                border: new OutlineInputBorder(
                                                  borderRadius: new BorderRadius.circular(20.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),
                                            onTap: () async {
                                              DateTime? pickeddate = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2100)
                                              );
                                              if (pickeddate != null){
                                                setState(() {
                                                  _tanggal.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                                  data["start_date"] = _tanggal.text;
                                                  print(data.toString());

                                                });
                                              }
                                            },
                                            controller: _tanggal,
                                            validator: (value) => value!.isEmpty ? 'Masukan Tanggal' : null
                                        ),
                                      ),
                                      SizedBox(width: 30,),

                                      Expanded(
                                        child: TextFormField(
                                            readOnly: true,
                                            style: TextStyle(color: Colors.white),
                                            decoration: new InputDecoration(
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white),
                                                ),
                                                prefixIcon: Icon(Icons.calendar_today,color: Colors.white,),
                                                labelText: "Akhir",
                                                labelStyle: TextStyle(
                                                  color: Colors.white, //<-- SEE HERE
                                                ),
                                                border: new OutlineInputBorder(
                                                  borderRadius: new BorderRadius.circular(20.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),
                                            onTap: () async {
                                              DateTime? pickeddate = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2100)
                                              );
                                              if (pickeddate != null){
                                                setState(() {
                                                  _tanggal2.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                                  data["end_date"] = _tanggal2.text;
                                                  print(data.toString());
                                                });
                                              }
                                            },
                                            controller: _tanggal2,
                                            validator: (value) => value!.isEmpty ? 'Masukan Tanggal' : null
                                        ),
                                      ),

                                    ],
                                  ),
                                ),*/


                                Row(
                                  children: [
                                    //SizedBox(width: ,),

                                    //Spacer(),

                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              //height: 20,
                                              width: MediaQuery.of(context).size.width*0.9,
                                              decoration: BoxDecoration(
                                                color: Colors.white38,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsets.all(5),
                                                    child: TabBar(
                                                      unselectedLabelColor: Colors.white,
                                                      labelColor: Colors.blue,
                                                      indicatorColor: Colors.blue,
                                                      indicatorWeight: 2,
                                                      indicator: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      controller: tabController,
                                                      onTap: (int index){
                                                        setState(() {

                                                          if (index == 1){
                                                            data["surat"] = "keluar";
                                                          }else if (index == 0){
                                                            data["surat"] = "masuk";
                                                          }else if (index == 2){
                                                            data["surat"] = "berkas akad";
                                                          }
                                                          getData();
                                                          print(data);

                                                          print('yang dipilih adalah $index');
                                                        });
                                                      },
                                                      tabs: [
                                                        Tab(
                                                          text: 'S Masuk',
                                                        ),
                                                        Tab(
                                                          text: 'S Keluar',
                                                        ),
                                                        Tab(
                                                          text: 'Akad',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    //Spacer(),
                                    /*ElevatedButton(
                                        onPressed: (){
                                          setState(() {
                                            getData();
                                          });
                                        },
                                        //child: Text("Cari")
                                        child: Icon(Icons.filter_alt,color: Colors.blue,),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.white70),
                                      ),

                                    ),*/
                                    //SizedBox(width: 20,),
                                  ],
                                ),





                              ],
                            ),



                          ],

                        ),

                      ),



                    ],
                  ),
                  Positioned(
                    top: 120,
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
                padding: const EdgeInsets.only(right: 10,left: 10),
                child: ListView.builder(
                    itemCount: jsonListConvert == null ? 0 : jsonListConvert.length,
                    itemBuilder: (BuildContext context,int index ){
                      return Card(
                        color: Colors.blue,
                        child: ListTile(
                          onTap:() {
                            print(jsonListConvert[index]);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainListDetail(idx: jsonListConvert[index],)));},
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
      )


 /*
          Container(
                  padding: EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),

                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      IconButton(
                          onPressed: (){
                            Navigator.of(context).pop(MaterialPageRoute(builder: (context)=> HomeScreen()));
                          },
                          icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,)

                      ),



                      Center(
                        child: Text("Masukan Rentang Tanggal Pembuatan Akta",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10,bottom: 8,right: 8,left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  readOnly: true,
                                  decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      prefixIcon: Icon(Icons.calendar_today,color: Colors.white,),
                                      labelText: "Awal",
                                      labelStyle: TextStyle(
                                        color: Colors.white, //<-- SEE HERE
                                      ),
                                      border: new OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(20.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      )
                                  ),
                                  onTap: () async {
                                    DateTime? pickeddate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100)
                                    );
                                    if (pickeddate != null){
                                      setState(() {
                                        _tanggal.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                        data["start_date"] = _tanggal.text;
                                        print(data.toString());

                                      });
                                    }
                                  },
                                  controller: _tanggal,
                                  validator: (value) => value!.isEmpty ? 'Masukan Tanggal' : null
                              ),
                            ),
                            SizedBox(width: 30,),

                            Expanded(
                              child: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(color: Colors.white),
                                  decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      prefixIcon: Icon(Icons.calendar_today,color: Colors.white,),
                                      labelText: "Akhir",
                                      labelStyle: TextStyle(
                                        color: Colors.white, //<-- SEE HERE
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(20.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      )
                                  ),
                                  onTap: () async {
                                    DateTime? pickeddate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100)
                                    );
                                    if (pickeddate != null){
                                      setState(() {
                                        _tanggal2.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                        data["end_date"] = _tanggal2.text;
                                        print(data.toString());
                                      });
                                    }
                                  },
                                  controller: _tanggal2,
                                  validator: (value) => value!.isEmpty ? 'Masukan Tanggal' : null
                              ),
                            ),

                          ],
                        ),
                      ),



                      Container(
                        margin: EdgeInsets.only(top: 5,bottom: 20),
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            //Icons.dashboard,
                            icon: Icon(Icons.arrow_back,size: 30,),
                            //size: 30,
                            color: Colors.white,
                            //onPressed: () => Scaffold.of(context).openDrawer(),
                            onPressed: () {
                              Navigator.of(context).pop(MaterialPageRoute(builder: (context)=> HomeScreen()));
                            },
                          ),
                          ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  getData();
                                });
                              },
                              child: Text("Cari")),
                        ],),

                    ],
                  ),
                ),

*/





/*


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

                                              Dio.Response response = await dio().delete('/posts/$pilihanid',
                                                options: Dio.Options(headers: {'Authorization': 'Bearer $token2'}),
                                              );

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


*/





    );
  }


  }

