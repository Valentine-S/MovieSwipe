import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_swipe/models/movie.api.dart';
import 'package:movie_swipe/screens/friends_page.dart';
import 'package:movie_swipe/widgets/swipe_card.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'log_in_page.dart';

enum MenuItem {
  item1,
  item2,
  item3,
  item4,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late Future<Movie> _movie;
  bool isLoading = true;
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    //getMovie();
    print('User: ');
    print(user);
    getMovies();
  }

  // Future<void> getMovie() async {
  //   _movie = MovieApi.getMoviebyID();
  //   setState(() {
  //     isLoading = false;
  //   });
  //   print('Movie Here: ');
  //   print(_movie);
  //   //print(_movie.title);
  // }

  Future<void> getMovies() async {
    _movies = MovieApi.getPopularMovies();
    setState(() {
      isLoading = false;
    });
    print('Movie Here: ');
    //print(_movies);
    print('Movie Title Here: ');
    //print(_movies[2].title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<MenuItem>(
              onSelected: (value) {
                if (value == MenuItem.item1) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FriendsPage(),
                  ));
                } else if (value == MenuItem.item2) {
                } else if (value == MenuItem.item3) {
                } else if (value == MenuItem.item4) {
                  FirebaseAuth.instance.signOut();
                }
              },
              icon: Icon(Icons.menu),
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: MenuItem.item1,
                      child: Text('Friends'),
                    ),
                    const PopupMenuItem(
                      value: MenuItem.item2,
                      child: Text('Item 2'),
                    ),
                    const PopupMenuItem(
                      value: MenuItem.item3,
                      child: Text('Item 3'),
                    ),
                    const PopupMenuItem(
                      value: MenuItem.item4,
                      child: Text('Sign Out'),
                    ),
                  ]),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon(Icons.settings),
            //SizedBox(width: 5),
            Text('Signed In: ' + user.email!),
            //SizedBox(width: 5),
            // ElevatedButton(
            //   onPressed: () {
            //     FirebaseAuth.instance.signOut();
            //   },
            //   //color: Colors.deepPurple[200],
            //   child: Text('sign out'),
            // )
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Movie>>(
          future: _movies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    id: snapshot.data![index].id,
                    title: snapshot.data![index].title,
                    overview: snapshot.data![index].overview,
                    posterpath: snapshot.data![index].posterpath,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
      

        /*
          //Button
          //Text(_movies[2].title),
          Text('Signed In as: ' + user.email!),
          //Text(_movie.getMovieTitle()),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            color: Colors.deepPurple[200],
            child: Text('sign out'),
          ),
        ],
      )),
    );
  }
}

*/

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           //Movie List
//           ListView.builder(
//             itemCount: 5,
//             itemBuilder: ((context, index) {
//               return MovieCard(
//                 id: _movies![index].id,
//                 title: _movies![index].title,
//                 overview: _movies![index].overview,
//                 posterpath: _movies![index].posterpath,
//               );
//             }),
//           ),
//           //Button
//           //Text(_movies[2].title),
//           Text('Signed In as: ' + user.email!),
//           //Text(_movie.getMovieTitle()),
//           MaterialButton(
//             onPressed: () {
//               FirebaseAuth.instance.signOut();
//             },
//             color: Colors.deepPurple[200],
//             child: Text('sign out'),
//           ),
//         ],
//       )),
//     );
//   }
// }





















/*
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("HOME"),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
*/