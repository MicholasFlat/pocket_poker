import 'package:flutter/material.dart';
import 'main.dart';
import 'deck.dart' as prefix0;

class CardWidget extends StatelessWidget
{
  final prefix0.Card card;
  CardWidget({this.card});
  @override
  Widget build(BuildContext context)
  {
    return new Card(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        color: Colors.white54,
        child: Container(
            padding: EdgeInsets.fromLTRB(1, 5, 30, 50),
            // margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
            child: Column(
              children: <Widget>[
                new Text(
                  card.number+card.suit,
                ),
              ],
            )
        )
    );
  }
}

bool allBet(List<Player> players, List<bool> hasBet)
{
  for(int i = 0; i < players.length; i++)
  {
    if(players[i].fold == false)
    {
      if(hasBet[i] == false)
      {
        print("allBet $i FALSE");
        return false;
      }
    }
  }
  return true;
}

bool equalBet(List<Player> players)
{
  for(int i = 0; i < players.length-1; i++)
  {
    if(!players[i].fold && !players[i+1].fold)
    {
      if(players[i].totalBet != players[i+1].totalBet)
      {
        print("equalBet $i FALSE");
        return false;
      }
    }
  }
  return true;
}

List<Player> betPhaseReset(List<Player> players)
{
  for(int i = 0; i < players.length; i++)
  {
    players[i].totalBet = 0;
  }

  return players;
}


