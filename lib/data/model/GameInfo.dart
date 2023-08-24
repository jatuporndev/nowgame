import 'Screenshot.dart';
import 'SystemRequirements.dart';

class GameInfo {
  final int id;
  final String title;
  final String thumbnail;
  final String status;
  final String shortDescription;
  final String description;
  final String gameUrl;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;
  final String freetogameProfileUrl;
  final SystemRequirements? minimumSystemRequirements;
  final List<Screenshot> screenshots;

  GameInfo({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.status,
    required this.shortDescription,
    required this.description,
    required this.gameUrl,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.freetogameProfileUrl,
    required this.minimumSystemRequirements,
    required this.screenshots,
  });

  GameInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        thumbnail = json['thumbnail'],
        status = json['status'],
        shortDescription = json['short_description'],
        description = json['description'],
        gameUrl = json['game_url'],
        genre = json['genre'],
        platform = json['platform'],
        publisher = json['publisher'],
        developer = json['developer'],
        releaseDate = json['release_date'],
        freetogameProfileUrl = json['freetogame_profile_url'],
        minimumSystemRequirements = json['minimum_system_requirements'] != null
            ? SystemRequirements.fromJson(json['minimum_system_requirements'])
            : null,
        screenshots = List<Screenshot>.from(json['screenshots']
            .map((screenshotJson) => Screenshot.fromJson(screenshotJson)));
}

