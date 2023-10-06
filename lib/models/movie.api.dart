import 'dart:convert';
import 'package:movie_swipe/main.dart';
import 'package:http/http.dart' as http;
import 'package:movie_swipe/models/movie.dart';

//String movieID = '80';

class MovieApi {
  static Future<Movie> getMoviebyID(String movieID) async {
    var uri = Uri.https('api.themoviedb.org', '3/movie/' + movieID,
        {'api_key': 'e67d188ae8cd6bb9f29a07b4c753ad0e'});

    final response = await http.get(uri);
    Map data = jsonDecode(response.body);
    return Movie.fromJson(data);
  }

  static Future<List<Movie>> getPopularMovies() async {
    var uri = Uri.https('api.themoviedb.org', '3/movie/popular',
        {'api_key': 'e67d188ae8cd6bb9f29a07b4c753ad0e'});

    final response = await http.get(uri);
    Map data = jsonDecode(response.body);
    List _temp = [];

    for (var i in data['results']) {
      _temp.add(i);
    }

    return Movie.moviesFromSnapshot(_temp);
  }

  static Future<List<Movie>> getMoviesbyID(List<String> ids) async {
    // Movie movie;
    // List<Movie> movies = [];
    // for (int i = 0; i < ids.length; i++) {
    //   movie = await getMoviebyID(ids[i]);
    //   movies.add(movie);
    // }
    // return movies;
    List<Movie> tempmovies;
    List _temp = [];
    for (int i = 0; i < ids.length; i++) {
      var uri = Uri.https('api.themoviedb.org', '3/movie/' + ids[i],
          {'api_key': 'e67d188ae8cd6bb9f29a07b4c753ad0e'});

      final response = await http.get(uri);
      Map data = jsonDecode(response.body);
      //Movie temp = Movie.fromJson(data);
      _temp.add(data);
      //tempmovies.add(temp);
    }
    return Movie.moviesFromSnapshot(_temp);
  }
}
