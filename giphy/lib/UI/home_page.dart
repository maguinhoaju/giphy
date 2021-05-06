import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map> _getGifs() async {
    //Trending
    //https://api.giphy.com/v1/gifs/trending?api_key=fRHv94BWNoi3ijG4mEW3urCaO931CDPA&limit=25&rating=g
    //Search
    //https://api.giphy.com/v1/gifs/search?api_key=fRHv94BWNoi3ijG4mEW3urCaO931CDPA&q=&limit=25&offset=0&rating=g&lang=en

    String _search;
    http.Response response;
    int _offset = 0;

    if (_search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=fRHv94BWNoi3ijG4mEW3urCaO931CDPA&limit=25&rating=g");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=fRHv94BWNoi3ijG4mEW3urCaO931CDPA&q=$_search&limit=25&offset=$_offset&rating=g&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise aqui:",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
