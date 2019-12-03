import 'package:flutter/material.dart';
import 'deck.dart' as prefix0;
import 'main.dart';
import 'poker_widgets.dart';

class FCDPoker extends StatefulWidget
{
  List<Player> players;
 FCDPoker({this.players});

  @override
  State<StatefulWidget> createState() => FCDState(
    players: players, playerTurn: 0, phase: 0
  );

}

class FCDState extends State<FCDPoker>
{
  List<Player> players;
  prefix0.Deck deck;
  int playerTurn, pot, winner, maximumBet;
  int phase; // 0: setup and dealing, 1: password enter screen 2: bet phase 1, 3: discard password screen, 4: discard cards, 5: bet phase 2, 6: winner phase
  FCDState({this.players, this.playerTurn, this.phase});
  bool discard;
  List<bool> hasbet, deadCards;

  TextEditingController betAmount= new TextEditingController();

  void setUpPhase()
  {
    setState(() {
      hasbet = List(players.length);
      deadCards = List(5);
      discard = false;
      deck = new prefix0.Deck();
      deck = deck.newDeckFull();
      maximumBet = pot = playerTurn = 0;
      for(int i = 0; i < players.length; i++)
      {
        players[i].totalBet = 0;
        players[i].fold = false;
        hasbet[i]=false;
        players[i].hand = new prefix0.Deck();
        players[i].hand.cards = <prefix0.Card>[];
        if(players[i].chips < 6)
          {
            players[i].chips+=10000;
          }
        players[i].chips -= 5;
        pot += 5;
      }
      for(int i = 0; i < 5; i++)
      {
        deadCards[i]=false;
      }

      players = betPhaseReset(players);

      for(int i = 0; i < 5; i++)
      {
        for(int j = 0; j<players.length; j++)
        {
          players[j].hand.cards.add(deck.dealCard(deck));
          deck = deck.removeCard(deck, players[j].hand.cards[i]);
        }
      }

      phase = 1;
    });
  }

  Widget enterPassword()
  {
    final TextEditingController userpass= new TextEditingController();

    while(players[playerTurn].fold)
      {
        playerTurn++;
        if(playerTurn == players.length)
          {
            playerTurn = 0;
          }
      }

    return Scaffold(
      appBar: AppBar(
        title: Text("Enter ${players[playerTurn].userName}'s Password"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: textBox("Enter ${players[playerTurn].userName}'s Password", userpass),
          ),
          RaisedButton(
            padding: new EdgeInsets.all(40.0),
            child: Text('Begin Betting',
            ),

            onPressed: () {
              if(userpass.text == players[playerTurn].password)
              {
                setState(() {

                  if(discard)
                    {
                      phase = 5;
                    }
                  else
                    {
                      phase = 2;
                    }
                });
              }
              else
              {
                userpass.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget enterDiscardPassword()
  {
    final TextEditingController userpass= new TextEditingController();

    while(players[playerTurn].fold)
    {
      playerTurn++;
      if(playerTurn == players.length)
      {
        playerTurn = 0;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Enter ${players[playerTurn].userName}'s Password"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: textBox("Enter ${players[playerTurn].userName}'s Password", userpass),
          ),
          RaisedButton(
            padding: new EdgeInsets.all(40.0),
            child: Text('Discard Cards',
            ),

            onPressed: () {
              if(userpass.text == players[playerTurn].password)
              {
                setState(() {

                  phase = 4;
                });
              }
              else
              {
                userpass.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget betPhase()
  {
    return Scaffold(
        appBar: AppBar(
          title: Text(players[playerTurn].userName + "'s turn"),
        ),
        body: BetWidget()
    );
  }

  Widget BetWidget()
  {
     return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Text("Total Pot: $pot"),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CardWidget(card: players[playerTurn].hand.cards[0]),
              CardWidget(card: players[playerTurn].hand.cards[1]),
              CardWidget(card: players[playerTurn].hand.cards[2]),
              CardWidget(card: players[playerTurn].hand.cards[3]),
              CardWidget(card: players[playerTurn].hand.cards[4]),
            ],
          ),
          numberBox("Minimum Bet: ${maximumBet-players[playerTurn].totalBet}", betAmount),

          Text("Your Chip Total: ${players[playerTurn].chips}"),

          BetButtons(maximumBet-players[playerTurn].totalBet),// BetButtons()
        ]
    );

  }

  Widget BetButtons(int minimumBet)
  {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //  numberBox("Minimum Bet: ${minimumBet}", betAmount),
        RaisedButton(
          padding: new EdgeInsets.all(10.0),
          child: Text('Call',
          ),
          onPressed: () {
            betAmount.clear();
            setState(() {
              players[playerTurn].chips-=minimumBet;
              players[playerTurn].totalBet += minimumBet;
              pot+=minimumBet;
              hasbet[playerTurn] = true;

              if(allBet(players, hasbet))
              {
                if(equalBet(players))
                {
                  playerTurn = 0;
                  phase++;
                }
                else
                {
                  if(playerTurn + 1 == players.length)
                  {
                    playerTurn = 0;
                    phase = 1;
                  }
                  else
                  {
                    phase = 1;
                    playerTurn++;
                  }
                }
              }
              else
              {
                if(playerTurn + 1 == players.length)
                {
                  playerTurn = 0;
                  phase = 1;
                }
                else
                {
                  phase = 1;
                  playerTurn++;
                }
              }
            });
          },
        ),
        RaisedButton(
          padding: new EdgeInsets.all(10.0),
          child: Text('Bet',),

          onPressed: () {


            if(isNum(betAmount.text))
            {
              if(int.parse(betAmount.text) > minimumBet)
              {
                setState(() {
                  players[playerTurn].chips-=int.parse(betAmount.text);
                  players[playerTurn].totalBet += int.parse(betAmount.text);
                  pot+=int.parse(betAmount.text);
                  hasbet[playerTurn] = true;

                  if(players[playerTurn].totalBet > maximumBet)
                  {
                    maximumBet = players[playerTurn].totalBet;
                  }

                  if(allBet(players, hasbet))
                  {
                    if(equalBet(players))
                    {
                      phase++;
                    }
                    else
                    {
                      if(playerTurn + 1 == players.length)
                      {
                        playerTurn = 0;
                        phase = 1;
                      }
                      else
                      {
                        phase = 1;
                        playerTurn++;
                      }
                    }
                  }
                  else
                  {

                    if(playerTurn + 1 == players.length)
                    {
                      playerTurn = 0;
                      phase = 1;
                    }
                    else
                    {
                      phase = 1;
                      playerTurn++;
                    }
                  }
                  betAmount.clear();
                });
              }
              else
              {
                betAmount.clear();
              }
            }
            else
            {
              betAmount.clear();
            }

          },
        ),
        RaisedButton(
          padding: new EdgeInsets.all(10.0),
          child: Text('Fold',
          ),
          onPressed: () {
            setState(() {
              players[playerTurn].fold = true;
              betAmount.clear();
              if(allBet(players, hasbet))
              {
                if(equalBet(players))
                {
                  phase++;
                }
                else
                {
                  if(playerTurn + 1 == players.length)
                  {
                    playerTurn = 0;
                    phase = 1;
                  }
                  else
                  {
                    phase = 1;
                    playerTurn++;
                  }
                }
              }
              else
              {
                if(playerTurn + 1 == players.length)
                {
                  playerTurn = 0;
                  phase = 1;
                }
                else
                {
                  phase = 1;
                  playerTurn++;
                }
              }
              if(playerTurn + 1 == players.length)
              {
                playerTurn = 0;
              }
              else
              {
                playerTurn++;
              }
            });
          },
        )

      ],
    );
  }

  Widget winnerPhase()
  {
    int highestScore = 0, highestPlayer;

    for(int i = 0; i < players.length; i++)
    {
      if(!players[i].fold)
      {
        prefix0.Deck finalhand = new prefix0.Deck();
        finalhand.cards = players[i].hand.cards;
        int temp = deck.Score(finalhand);
        if(temp > highestScore)
        {
          highestScore = temp;
          highestPlayer = i;
        }
      }

    }

    winner  = highestPlayer;
    players[winner].chips+= pot;
    players[winner].hand = players[winner].hand.sortBySuit(players[winner].hand);

    return Scaffold(
        appBar: AppBar(title: Text("The winner is " + players[winner].userName +"!"),),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CardWidget(card: players[winner].hand.cards[0]),
                CardWidget(card: players[winner].hand.cards[1]),
                CardWidget(card: players[winner].hand.cards[2]),
                CardWidget(card: players[winner].hand.cards[3]),
                CardWidget(card: players[winner].hand.cards[4]),
              ],
            ),

            Divider(height: 50),
            RaisedButton(
              padding: new EdgeInsets.all(40.0),
              child: Text('Begin New Round',
              ),

              onPressed: () {
                setState(() {
                  phase = 0;
                });
              },
            ),
          ],
        )
    );
  }

  Widget discardButton(int index)
  {
    if(deadCards[index])
      {
        return RaisedButton(
          padding: EdgeInsets.fromLTRB(1, 5, 9, 30),
          color: Colors.green,
          child: Text(players[playerTurn].hand.cards[index].number + players[playerTurn].hand.cards[index].suit, style: TextStyle(color: Colors.red),),
          onPressed: ()
          {
            setState(()
            {
              playerTurn = playerTurn;
              deadCards[index] = false;
            });

          },
        );
      }
    else
      {
        return RaisedButton(
          padding: EdgeInsets.fromLTRB(1, 5, 9, 6),
          child: Text(players[playerTurn].hand.cards[index].number + players[playerTurn].hand.cards[index].suit),
          onPressed: ()
          {
            setState(()
            {
              playerTurn = playerTurn;
              deadCards[index] = true;
            });

          },
        );
      }
  }

  Widget discardPhase()
  {



    return Scaffold(
      appBar: AppBar(
        title: Text("${players[playerTurn].userName}, discard your cards"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              discardButton(0),
              Divider(thickness: 3),
              discardButton(1),
              Divider(thickness: 3),
              discardButton(2),

            ],
          ),
          Row(
            children: <Widget>[
              discardButton(3),
              Divider(thickness: 3),
              discardButton(4),
            ],
          ),
          RaisedButton(
            padding: new EdgeInsets.all(40.0),
            child: Text('Discard Chosen Cards',
            ),

            onPressed: () {
              prefix0.Deck tempD = deck;
              prefix0.Deck tempH = players[playerTurn].hand;
              for(int i = 0; i < 5; i++)
              {
                if(deadCards[i])
                  {
                    tempH.cards[i] = tempD.dealCard(tempD);
                    tempD.cards.remove(tempH.cards[i]);
                  }
              }

              setState(() {
                for(int i = 0; i < 5; i++)
                  {
                    deadCards[i] = false;
                  }

                deck = tempD;
                players[playerTurn].hand = tempH ;

                if(playerTurn + 1 == players.length)
                  {
                    playerTurn = 0;
                    discard = true;
                    phase = 1;
                    players = betPhaseReset(players);
                    maximumBet = 0;

                    for(int i = 0; i < players.length; i++)
                    {
                      hasbet[i]=false;
                    }

                  }
                else
                  {
                    playerTurn++;
                    phase = 3;
                    print("$playerTurn");
                  }



              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    switch(phase)
    {
      case 0:
        {
          return Scaffold(
              appBar: AppBar(
                  title: Text("Start New Round")
              ),
              body: Center(

                child: RaisedButton(
                  padding: new EdgeInsets.all(40.0),
                  child: Text('Begin New Round',
                  ),

                  onPressed: () {
                    setUpPhase();
                  }, // onPressed
                ),
              )
          );
        }
        break;
      case 1:
        {
          return enterPassword();
        }
        break;
      case 2:
        {
          return betPhase();
        }
        break;
      case 3:
        {
          while(players[playerTurn].fold)
            {
              playerTurn++;
              if(playerTurn+1 == players.length)
                {
                  setState(() {
                    playerTurn = 0;
                    discard = true;
                    phase = 1;
                    players = betPhaseReset(players);
                    maximumBet = 0;

                    for(int i = 0; i < players.length; i++)
                    {
                      hasbet[i]=false;
                    }
                  });
                }
            }
          return enterDiscardPassword();
        }
        break;
      case 4:
        {
          return discardPhase();
        }
        break;
      case 5:
        {
          return betPhase();
        }
        break;
      case 6:
        {
          return winnerPhase();
        }
        break;
    }
  }
}
