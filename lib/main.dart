import 'package:bloodandroses/globals.dart';
import 'package:bloodandroses/instructions.dart';
import 'package:flutter/material.dart';
import 'globals.dart';
import 'cardList.dart';
import 'allCards.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood and Roses',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StartPage()//MyHomePage(title: 'Blood and Roses'),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 30, 30, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 400,
                height: 100,
                child: RaisedButton(
                  child: Text("Start"),
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(title: 'Blood and Roses')
                      )
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 400,
                height: 100,
                child: RaisedButton(
                  child: Text("Instructions"),
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Instructions()
                      )
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );  
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> _showAlert(String title, String description) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(description),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  remove() {
    setState(() {
      playersCards = [];
    });
  }

  onCardTap(card){
    if(playersTurn && !hasTraded && hasRolled){
      List<CardData> cardList = listOfCard(card);
      setState(() {
        if(cardList == playersCards){
          moveCard(playersCards, card, playersTradingCards);
        } else if(cardList == playersTradingCards){
          moveCard(playersTradingCards, card, playersCards);
        } else if(cardList == computersCards){
          moveCard(computersCards, card, computersTradingCards);
        } else if(cardList == computersTradingCards){
          moveCard(computersTradingCards, card, computersCards);
        }
      });
    }
  }

  bool hasTraded = false;
 
  onTrade(bool fromPlayer) async {
    setState(() => hasTraded = true);
    bool accepted = false;
    if(fromPlayer){
      accepted = await Future.delayed(Duration(seconds: 2), doesComputerAccept);
      if(accepted){
        tradeAccepted();
      } else {
        tradeDenied();
      }
    }
  }

  bool doesComputerAccept(){
    int playerTotal = 0;
    playersTradingCards.forEach((e) => playerTotal += e.points);
    int computerTotal = 0;
    computersTradingCards.forEach((e) => computerTotal += e.points);
    bool result = ((computerTotal - playerTotal).abs() < threshold + thresholdIncrease || playerTotal > computerTotal);
    if(result){
      _showAlert("Accepted", "Your opponent accepted your trade request");
    } else {
      _showAlert("Denied", "Your opponent denied your trade request");
    }
    return result;
  }

  tradeAccepted(){
    setState(() {
      alreadyTraded.addAll(playersTradingCards);
      alreadyTraded.addAll(computersTradingCards);
      while(computersTradingCards.length + playersTradingCards.length > 0){
        for(CardData card in playersTradingCards)
        moveCard(playersTradingCards, card, computersCards);
        for(CardData card in computersTradingCards)
        moveCard(computersTradingCards, card, playersCards);
      }
    });
    swapTurns();
  }

  tradeDenied({bool swap = true}){
    setState(() {
      while(computersTradingCards.length + playersTradingCards.length > 0){
      for(CardData card in playersTradingCards){
        moveCard(playersTradingCards, card, playersCards);
      }
      for(CardData card in computersTradingCards) {
        moveCard(computersTradingCards, card, computersCards);
      }
      }
    });
    if(swap) swapTurns();
  }

  roll(bool fromPlayer){
    setState(() {
      if(fromPlayer){
        playersCards.add(getRandomCard());
        hasRolled = true;
      } else {
        computersCards.add(getRandomCard());
      }
    });
  }

  CardData getRandomCard(){
    var rng = new Random();
    CardData selected = allCards[rng.nextInt(allCards.length)];
    allCards.remove(selected);
    return selected;
  }

  swapTurns() async {
    if(!checkWin()){
    if(playersTradingCards.isNotEmpty || computersTradingCards.isNotEmpty) tradeDenied(swap: false);
    setState((){
      playersTurn = !playersTurn;
      hasRolled = false;
      hasTraded = false;
    });
    if(!playersTurn) await computersTurn();
    }
  }

  computersTurn() async {
    await Future.delayed(Duration(seconds: 2), (){});
    await Future.delayed(Duration(seconds: 1), roll(false));
    await Future.delayed(Duration(seconds: 1), computerSuggestTrade);
  }

  computerSuggestTrade() async {
    CardData selectedPlayerCard;
    CardData selectedComputerCard;
    for(CardData card in playersCards) {
      var _selectedComputerCard = computersCards.firstWhere((e) => (e.points - card.points).abs() < threshold, orElse: (){return null;});
      if(_selectedComputerCard != null){
        selectedPlayerCard = card;
        selectedComputerCard = _selectedComputerCard;
      }
    }
    if(selectedPlayerCard != null && selectedComputerCard != null && !alreadyTraded.contains(selectedComputerCard) && !alreadyTraded.contains(selectedPlayerCard)){
      moveCard(computersCards, selectedComputerCard, computersTradingCards);
      moveCard(playersCards, selectedPlayerCard, playersTradingCards);
      setState(() {});
      _showAlert("Trade Request", "Your opponent has requested a trade. Click 'Accept' or 'Deny'");
    } else {
      swapTurns();
    }
  }

  Widget getButton(String text, Function onPressed, double height, double width){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: height / 5 - 50,
        width: width * 0.2,
        child: RaisedButton(
          onPressed: onPressed,
          child: Text(text, style: TextStyle(fontSize: 50),),
        ),
      ),
    );
  }

  bool checkWin(){
    if(playersCards.length + computersCards.length >= 10){
      int playerScore = 0;
      int computerScore = 0;
      playersCards.where((e) => !e.blood).forEach((e) => playerScore += e.points);
      computersCards.where((e) => e.blood).forEach((e) => computerScore += e.points);
      int reduction = 10000000;
      if(playerScore > computerScore){
        _showAlert("You Won!", 
        "You won the game with " + (playerScore / reduction).toString() + " points." +
        " The computer had " + (computerScore / reduction).toString() + " points.");
      } else if (playerScore < computerScore){
        _showAlert("You Lost!", 
        "You lost the game with " + (playerScore / reduction).toString() + " points." +
        " The computer had " + (computerScore / reduction).toString() + " points.");
      } else {
        _showAlert("You Tied!", 
        "You tied the game. You both had " + playerScore.toString() + " points.");
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double sectionHeight = height / 3 - 56 / 3;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: <Widget>[
          Container(
            color: Color.fromRGBO(100, 100, 100, 1),
            height: height,
            width: width * 0.2,
            child: Column(
              children: [
                getButton("Roll", (playersTurn && !hasRolled) ? () => roll(true) : null, height, width),
                getButton("Trade", (playersTurn && hasRolled && playersTradingCards.isNotEmpty && computersTradingCards.isNotEmpty && !hasTraded) ? () => onTrade(true) : null, height, width),
                getButton("Skip", (playersTurn && hasRolled) ? swapTurns : null, height, width),
                getButton("Accept", (playersTradingCards.isNotEmpty && computersTradingCards.isNotEmpty & !playersTurn) ? tradeAccepted : null, height, width),
                getButton("Deny", (playersTradingCards.isNotEmpty && computersTradingCards.isNotEmpty & !playersTurn) ? tradeDenied : null, height, width)
              ],
            ),
          ),
          Container(
            color: Colors.black,
            height: height,
            width: width * 0.8,
            child: Column(
              children: [
                Container(
                  height: sectionHeight,
                  color: Colors.red,
                  child: CardList(widgetsFromCards(computersCards, onCardTap)),
                ),
                Row(
                  children: [
                    Container(
                      height: sectionHeight,
                      width: (width * 0.8) / 2,
                      color: Color.fromRGBO(50, 50, 50, 0.5),
                      child: CardList(widgetsFromCards(playersTradingCards, onCardTap)),
                    ),
                    Container(
                      height: sectionHeight,
                      width: (width * 0.8) / 2,
                      color: Colors.red.withOpacity(0.5),
                      child: CardList(widgetsFromCards(computersTradingCards, onCardTap)),
                    ),
                  ],
                ),
                Container(
                  height: sectionHeight,
                  color: Color.fromRGBO(50, 50, 50, 1),
                  child: CardList(widgetsFromCards(playersCards, onCardTap))
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
