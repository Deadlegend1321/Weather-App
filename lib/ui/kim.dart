import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Kim extends StatefulWidget {
  @override
  _KimState createState() => _KimState();
}

class _KimState extends State<Kim> {
static String _cityE;
  Future nxtscreen(BuildContext context)async
  {
    Map result = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context)
      {
        return new Chng();
      })
    );
    if (result != null && result.containsKey('enter')){
      _cityE=result['enter'];
      print(_cityE.toString());
    }
  }
  void shows() async
  {
    Map data = await getweather(util.appid, util.fcity);
  }
  @override
  Widget build(BuildContext context) {
    print(_cityE.toString());
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Veather"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu,color: Colors.redAccent) ,
              onPressed: () {nxtscreen(context);})
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text('${_cityE == null ? util.fcity : _cityE}',
            style: cty(),),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 290.0, 0.0, 0.0),
            child: update(_cityE),
            ),
        ],
      )
    );
  }
}
Future <Map> getweather(String appid ,String city) async
{
  String apiurl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
  '${util.appid}&units=imperial';
  http.Response response = await http.get(apiurl);
  return json.decode(response.body);
}
Widget update(String city)
{
  return new FutureBuilder(
    future: getweather(util.appid, city == null ? util.fcity : city),
      builder:(BuildContext context, AsyncSnapshot<Map> snapshot)
  {
    if(snapshot.hasData)
      {
        Map content = snapshot.data;
        return new Container(
          child: new Column(
            children: <Widget>[
              new ListTile(
                title: new Text(content['main']['temp'].toString(),
                style: new TextStyle(color: Colors.white,
                fontStyle: FontStyle.normal,
                fontSize: 50.0),),
              ),
            ],
          ),
        );
      }
    else
      return new Container();
  });
}

class Chng extends StatelessWidget {
  final _cityfcont = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/white_snow.png',
                    width: 490.0,
                    height: 1200.0,
                    fit: BoxFit.fill,),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityfcont,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: FlatButton(onPressed: (){
                  Navigator.pop(context,{
                    'enter': _cityfcont.text
                  });
                },
                    textColor: Colors.white,
                    color: Colors.red
                    ,child: Text('Veather')),
              )
            ],
          )
        ],
      ),
    );
  }
}


TextStyle cty()
{
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontSize: 23.0
  );
}