import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';

class SwipeCard extends StatelessWidget {
  const SwipeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Swipable(
      child: Container(
        color: Colors.deepPurple[200],
      ),
    );
  }
}
