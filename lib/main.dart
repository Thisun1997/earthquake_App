import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:wheather/modules/global.dart';

import 'modules/whetherApi.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wheather App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Wheather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  WhetherApi whetherApi;
  
  fetchposts() async{
    var response = await http.get(EARTHQUAKE_URL,headers: {"content-Type":"application/json"});
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      whetherApi = WhetherApi.fromJson(data);
      return whetherApi;
    }
    else{
      return "Sorry for Inconvenience, Server Under Maintainance";
    }
  }

  List<Color> colors = [Colors.yellow,Colors.green,Colors.blue,Colors.orange,Colors.red];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.title),
      ),
      body:Container(
        child:  FutureBuilder(
            future: fetchposts(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child:Center(
                    child: CircularProgressIndicator(),     //if no  data, this is shown
                  )
                );
              }
              else if(snapshot.data != null){
                if(snapshot.data == "Sorry for Inconvenience, Server Under Maintainance"){
                  return Container(
                    child:Center(
                      child: Text(snapshot.data),     //if no  data, this is shown
                    )
                  );
                }
                else{
                  return ListView.builder(
                    itemCount: whetherApi.features.length,
                    itemBuilder: (BuildContext context,int index){
                      List<String> places = whetherApi.features[index].properties.place.split(',');

                      return Container(
                        decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Color(0xFFE0E0E0),
                                offset: Offset(0.5, 0.5),
                                blurRadius: 10.0,
                              ),
                            ],
                            shape: BoxShape.rectangle,
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width/6,
                              child:
                            Container(
                              
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                    color:colors[(whetherApi.features[index].properties.mag).ceil()>4?4:(whetherApi.features[index].properties.mag).ceil()==0?0:(whetherApi.features[index].properties.mag).ceil()],

                              ),
                              child:Container(
                                margin: EdgeInsets.only(left:MediaQuery.of(context).size.width/19),
                                child:Text((whetherApi.features[index].properties.mag).ceil().toString(),style: TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.w700),))
                            )),

                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget>[
                              Text(places[places.length-1],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                                Text(places[0],style: TextStyle(fontSize: 12))

                              ]
                              ),
                            )
                          ],
                        ),
                      );
                      });
                          }
                        }
                      },
          )
          
       )
      );

    
  }
}
