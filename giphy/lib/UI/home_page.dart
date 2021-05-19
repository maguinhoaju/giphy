import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:giphy/UI/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;
  int _limit = 19;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search.isEmpty) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=fRHv94BWNoi3ijG4mEW3urCaO931CDPA&limit=$_limit&rating=g");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=fRHv94BWNoi3ijG4mEW3urCaO931CDPA&q=$_search&limit=$_limit&offset=$_offset&rating=g&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      //print(map);
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
              onSubmitted: (text) {
                setState(() {
                  _search = text.trim();
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _createGifTable(context, snapshot);
                  }
                }),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null || _search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            },
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 20;
                });
              },
            ),
          );
        }
      },
    );
  }
}
