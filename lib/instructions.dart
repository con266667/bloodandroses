import 'package:flutter/material.dart';

class Instructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 30, 30, 1),
      appBar: AppBar(
        title: Text('Blood and Roses Instructions')
      ),
      body: Center(
        child: Container(
          width: 500,
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 20),
              Text("Instructions", style: TextStyle(fontSize: 60, color: Colors.white), textAlign: TextAlign.center,),


              Container(height: 10),
              Text("Starting the game", style: TextStyle(fontSize: 30, color: Colors.white)),
              Container(height: 5),
              Text("Click the 'Roll' button and a card will be given to you. " + 
              "This card will either be a Blood (grey) or a Rose (white). " + 
              "The Blood cards contain the worst atrocities humans have created. " + 
              "The Rose cards contain artworks, scientific breakthroughs, architechture, and inventions. " + 
              "You will play on the Rose side. Your cards will be shown in the bottom row of the screen, identifiable by it's grey colour.", 
              style: TextStyle(fontSize: 15, color: Colors.white)),
              

              Container(height: 10),
              Text("Trading", style: TextStyle(fontSize: 30, color: Colors.white)),
              Container(height: 5),
              Text("In the first round you will not be able to trade. Simply press skip to let your opponent (the computer) roll. " + 
              "In each subsequent round you will have the option to trade. " + 
              "To trade, you will need to create a trade request. " + 
              "This will include the cards you are offering and the cards you want to receive. " + 
              "To offer a card, click it and it will move to the trading area. Click it again to reverse this. The same process is required to request cards. " +
              "When you are done, click 'Trade'. If your opponent accepts the trade, the trade request will be excecuted. " +
              "Your opponent may also want to trade. When this happens, the accept and deny buttons will be enabled." + 
              "\nNote: You must roll before you can trade", 
              style: TextStyle(fontSize: 15, color: Colors.white)),


              Container(height: 10),
              Text("How to win", style: TextStyle(fontSize: 30, color: Colors.white)),
              Container(height: 5),
              Text(
              "Once 10 cards are drawn and traded, a winner will be decided. " + 
              "In the new version of history, all the Rose cards you have happened and your Blood cards were prevented. " +
              "But all your opponents Blood cards happened and all their Rose cards were prevented. " +
              "Each card has a unknown number of points. " + 
              "The number of points a card has is based on the significance of the card. " + 
              "For example, the value of a particular war is based on the number of casulties and " +
              "the value of an art piece is based on its market price. " +
              r"On average, one life is worth $10,000. " +
              "Your total amount of points is the total value of the Rose cards you have. " + 
              "The total amount of points your opponent has is the total value of their Blood cards.", 
              style: TextStyle(fontSize: 15, color: Colors.white)),
            ]
          ),
        )
      ),
    );
  }
}