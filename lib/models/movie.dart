import 'package:firebase_auth/firebase_auth.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterpath;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterpath,
  });

  factory Movie.fromJson(dynamic json) {
    return Movie(
      id: json['id'] as int,
      title: json['original_title'] as String,
      overview: json['overview'] as String,
      posterpath: json['poster_path'] as String,
    );
  }

  static List<Movie> moviesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Movie.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'Movie: {id: $id, title: $title, overview: $overview, posterpath: $posterpath}';
  }

  String getMovieTitle() {
    return 'asdad $title';
  }
}
