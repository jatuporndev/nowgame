import 'dart:convert';

import 'package:nowgame/Service/HttpService.dart';
import 'package:nowgame/data/model/Game.dart';

import '../data/model/GameInfo.dart';

class GameRepository {

  Future<List<Game>> fetchGames() async {
    final url = 'https://www.freetogame.com/api/games';
    final response = await HttpService().getMethod(url);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Game.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load game');
    }
  }

  Future<GameInfo> fetchGameInfoById(int id) async {
    final url = 'https://www.freetogame.com/api/game?id=${id}';
    final response = await HttpService().getMethod(url);
    if(response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return GameInfo.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load game');
    }
  }

}

