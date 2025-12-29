class GameData {
  final List<ArcadeGame> arcadeClassicGames;

  GameData({required this.arcadeClassicGames});

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      arcadeClassicGames: (json['arcadeClassicGames'] as List)
          .map((game) => ArcadeGame.fromJson(game))
          .toList(),
    );
  }
}

class ArcadeGame {
  final int id;
  final String name;
  final String chineseName;
  final int releaseYear;
  final String developer;
  final String publisher;
  final String genre;
  final List<String> platforms;
  final String description;
  final String detailedDescription;
  final List<String> gameplayMechanics;
  final List<String> iconicFeatures;
  final TechnicalDetails technicalDetails;
  final String culturalImpact;
  final String legacy;
  final List<String> awards;
  final GameImages images;

  ArcadeGame({
    required this.id,
    required this.name,
    required this.chineseName,
    required this.releaseYear,
    required this.developer,
    required this.publisher,
    required this.genre,
    required this.platforms,
    required this.description,
    required this.detailedDescription,
    required this.gameplayMechanics,
    required this.iconicFeatures,
    required this.technicalDetails,
    required this.culturalImpact,
    required this.legacy,
    required this.awards,
    required this.images,
  });

  factory ArcadeGame.fromJson(Map<String, dynamic> json) {
    return ArcadeGame(
      id: json['id'],
      name: json['name'],
      chineseName: json['chineseName'],
      releaseYear: json['releaseYear'],
      developer: json['developer'],
      publisher: json['publisher'],
      genre: json['genre'],
      platforms: (json['platforms'] as List).map((p) => p.toString()).toList(),
      description: json['description'],
      detailedDescription: json['detailedDescription'],
      gameplayMechanics:
          (json['gameplayMechanics'] as List).map((m) => m.toString()).toList(),
      iconicFeatures:
          (json['iconicFeatures'] as List).map((f) => f.toString()).toList(),
      technicalDetails: TechnicalDetails.fromJson(json['technicalDetails']),
      culturalImpact: json['culturalImpact'],
      legacy: json['legacy'],
      awards: (json['awards'] as List).map((a) => a.toString()).toList(),
      images: GameImages.fromJson(json['images']),
    );
  }
}

class TechnicalDetails {
  final String? resolution;
  final String? cpu;
  final String? sound;
  final String? display;
  final String? originalPlatform;
  final String? firstArcadeVersion;

  TechnicalDetails({
    this.resolution,
    this.cpu,
    this.sound,
    this.display,
    this.originalPlatform,
    this.firstArcadeVersion,
  });

  factory TechnicalDetails.fromJson(Map<String, dynamic> json) {
    return TechnicalDetails(
      resolution: json['resolution'],
      cpu: json['cpu'],
      sound: json['sound'],
      display: json['display'],
      originalPlatform: json['originalPlatform'],
      firstArcadeVersion: json['firstArcadeVersion'],
    );
  }
}

class GameImages {
  final String icon;

  GameImages({required this.icon});

  factory GameImages.fromJson(Map<String, dynamic> json) {
    return GameImages(
      icon: json['icon'],
    );
  }
}

