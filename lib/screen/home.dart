import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/model/Game.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Game>> futureGame;

  @override
  void initState() {
    super.initState();
    futureGame = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 8,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Scrollbar(
            interactive: true,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "NOWGAME",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 26,),
                  FutureBuilder<List<Game>>(
                    future: futureGame,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: const CircularProgressIndicator(),
                        ); // While waiting for data
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        List<Game>? games = snapshot.data;
                        return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: games!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final game = games[index];
                                return Padding(padding: EdgeInsets.only(bottom: 24),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(11.0),
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(11.0),
                                            child: CachedNetworkImage(
                                              imageUrl: game.thumbnail,
                                              placeholder: (context, url) => ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(11.0),
                                                  child: Image.asset(
                                                      'assets/images/thumbnail.jpg')),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(padding: EdgeInsets.only(left: 6),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    game.title,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    game.developer + " • " + game.publisher,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(4)),
                                                            color: Colors.deepOrangeAccent),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(6),
                                                          child: Text(
                                                            game.genre,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 12),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(4)),
                                                            color: Colors.cyanAccent),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(6),
                                                          child: Text(
                                                            game.platform,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 12),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 6,)
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      print("Tapped on container" + game.id.toString());
                                    },
                                  ),
                                );
                              },
                            ));
                      } else {
                        return Text(
                            'No data available.'); // Handle case when no data is available
                      }
                    },
                  )
                ],
              )
              ),
            ),
          ),
        );
  }
}

Future<List<Game>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('https://www.freetogame.com/api/games'));
  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((e) => Game.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load game');
  }
}
