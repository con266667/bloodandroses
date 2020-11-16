import 'package:flutter/material.dart';
import 'card.dart';

bool playersTurn = true;
bool hasRolled = false;

class CardData {
  String title = "";
  String imageurl = "";
  bool blood = false;
  int points = 0;
}

int threshold = 35000000000;
int thresholdIncrease = 5000000000;

List<CardData> playersCards = [];
List<CardData> playersTradingCards = [];
List<CardData> computersCards = [];
List<CardData> computersTradingCards = [];

List<CardData> alreadyTraded = [];

List<Widget> widgetsFromCards(List<CardData> cards, Function ontap){
  List<Widget> _playingCards = [];
  for(CardData card in cards) _playingCards.add(PlayingCard(card, ontap));
  return _playingCards; 
}

moveCard(List<CardData> listFrom, CardData item, List<CardData> listTo){
  listTo.add(item);
  listFrom.remove(item);
}

List<CardData> listOfCard (CardData card){
  if(playersCards.contains(card)) return playersCards;
  if(playersTradingCards.contains(card)) return playersTradingCards;
  if(computersCards.contains(card)) return computersCards;
  if(computersTradingCards.contains(card)) return computersTradingCards;
  return null;
}