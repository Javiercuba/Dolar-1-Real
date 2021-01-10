import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance";

void main() async {
  runApp(MaterialApp(home: Home()));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realcontroller = TextEditingController();
  final dolarcontroller = TextEditingController();
  final eurocontroller = TextEditingController();


  double euro,dolar;


  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
    }else {
      double real = double.parse(text);
      dolarcontroller.text = (real / dolar).toStringAsFixed(2);
      eurocontroller.text = (real / euro).toStringAsFixed(2);
    }
  }
  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
    }else {
      double dolar = double.parse(text);
      realcontroller.text = (dolar * this.dolar).toStringAsFixed(2);
      eurocontroller.text = ((dolar * this.dolar) / euro).toStringAsFixed(2);
    }
  }
  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
    }else {
      double euro = double.parse(text);
      realcontroller.text = (euro * this.euro).toStringAsFixed(2);
      dolarcontroller.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
    }
  }
  void _clearAll(){
    realcontroller.text = "";
    dolarcontroller.text = "";
    eurocontroller.text = "";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Dolar 1 Real",style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold),),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {

                case (ConnectionState.none):
                case (ConnectionState.waiting):
                  return Center(
                      child: Text(
                            "Carregando Dados..",
                                style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.0,),

                            textAlign: TextAlign.center,  )
                  );
                default:
                  if(snapshot.hasError){
                    return Center(
                        child: Text(
                          "Erro ao carregar Dados",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,),

                          textAlign: TextAlign.center,  )
                    );
                  }else{
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:<Widget> [
                          Icon(Icons.monetization_on,size: 150.0, color: Colors.amber),
                          buildTextField("Real","R\$",realcontroller,_realChanged),

                          Divider(),
                          buildTextField("Dolar", "US\$",dolarcontroller,_dolarChanged),

                          Divider(),
                          buildTextField("Euro", "US\$",eurocontroller,_euroChanged),

                        ],
                      ),
                    );
                  }

              }
            }));
  }
}

Widget buildTextField(String label,String prefix, TextEditingController c,Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber,fontSize: 20.0),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    onChanged: f ,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}


