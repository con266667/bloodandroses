import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  CardList(this.cards);
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: cards,
    );
  }
}