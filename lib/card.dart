import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart';

class PlayingCard extends StatelessWidget {
  PlayingCard(this.card, this.ontap);
  final CardData card;
  final Function ontap;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: 250,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => ontap(card),
          child: Card(
            color: card.blood ? Color.fromRGBO(150, 150, 150, 1) : Colors.white,
            child: Column(
              children: [
                Container(height: 20),
                Text(card.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Container(height: 15),
                Container(
                  height: height / 3 - 120,
                  child: FittedBox(
                    fit: BoxFit.fill,
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(card.imageurl),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}