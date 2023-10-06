import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_swipable/flutter_swipable.dart';

import '../services/like.dart';

class MovieCard extends StatelessWidget {
  const MovieCard(
      {Key? key,
      required this.id,
      required this.title,
      required this.overview,
      required this.posterpath})
      : super(key: key);

  final int id;
  final String title;
  final String overview;
  final String posterpath;

  /*
  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  MovieCard({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterpath,
  });
  */

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Swipable(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'ID: ' + id.toString(),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(overview),
              SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () {
                    addLiked(id);
                  },
                  child: Text('Like')),
              Image(
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w400/' + posterpath)),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
