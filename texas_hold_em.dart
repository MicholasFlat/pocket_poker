import 'package:flutter/material.dart';
import 'deck.dart' as prefix0;
import 'main.dart';
import 'poker_widgets.dart';

class THEPoker extends StatefulWidget
{
  List<Player> players;
  THEPoker({this.players});

  @override
  State createState()=> new THEState(players: players, playerTurn: 0, phase: 0);
}


class THEState extends State<THEPoker>
{
  List<Player> players;
  prefix0.Deck deck;
  prefix0.Deck communityCards;
  int playerTurn, pot, winner, maximumBet;
  int phase; // 0: setup and dealing, 1: password enter screen 2: bet phase 1, 3: deal 3 commcards, 4: bet phase 2, 5: deal 1 commcard, 6: bet phase 3, 7: deal 1 commcard, 8: bet phase 4, 9: show the cards and show winning hand
  THEState({this.players, this.playerTurn, this.phase});
  List<bool> hasbet;

  TextEditingController betAmount= new TextEditingController();



  void setUpPhase ()
  {

    setState(() {
      communityCards = prefix0.Deck();
      communityCards.cards = <prefix0.Card>[];
      hasbet = List(players.length);
      deck = new prefix0.Deck();
      deck = deck.newDeckFull();
      maximumBet = pot = playerTurn = 0;
      phase = 1;
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
      players = betPhaseReset(players);

      for(int i = 0; i < 2; i++)
      {
        for(int j = 0; j<players.length; j++)
        {
          players[j].hand.cards.add(deck.dealCard(deck));
          deck = deck.removeCard(deck, players[j].hand.cards[i]);
        }
      }

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
            child: Text('begin round',
            ),

            onPressed: () {
              if(userpass.text == players[playerTurn].password)
              {
                setState(() {
                  switch (communityCards.cards.length)
                  {
                    case 0:{phase = 2;}
                    break;
                    case 3:{phase = 4;}
                    break;
                    case 4:{phase = 6;}
                    break;
                    case 5:{phase = 8;}
                    break;
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

  Widget betPhase()
  {
    return Scaffold(
        appBar: AppBar(
          title: Text(players[playerTurn].userName + "'s turn"),
        ),
        body: BetWidget()
    );
  }

  Widget dealCommCard(int cardsToDeal)
  {

    prefix0.Deck tempDeck = deck;
    prefix0.Card burn = tempDeck.dealCard(tempDeck);
    tempDeck = tempDeck.removeCard(tempDeck, burn);
    prefix0.Deck CC = communityCards;
    for(int i = 0; i < cardsToDeal; i++)
    {
      burn = deck.dealCard(deck);
      CC.cards.add(burn);
      deck = deck.removeCard(deck, burn);
    }



    for(int i = 0; i < CC.cards.length; i++)
      {
        print(CC.cards[i].number + CC.cards[i].suit);
      }




    return Scaffold(
        appBar: AppBar(
            title: Text("Start Next Round")
        ),
        body: Center(

          child: RaisedButton(
            padding: new EdgeInsets.all(40.0),
            child: Text('Begin New Round',
            ),

            onPressed: () {
              setState(() {

                for(int i = 0; i < players.length; i++)
                {
                  hasbet[i]=false;
                }

                deck = tempDeck;
                communityCards = CC;
                phase = 1;
                players = betPhaseReset(players);
                maximumBet = 0;

                print("State set to $phase");
              });
            }, // onPressed
          ),
        )
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
            finalhand.cards = players[i].hand.cards + communityCards.cards;
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
            ],
          ),
          Divider(height: 15),
          Row(
            children: <Widget>[
              CardWidget(card: communityCards.cards[0]),
              CardWidget(card: communityCards.cards[1]),
              CardWidget(card: communityCards.cards[2]),
              CardWidget(card: communityCards.cards[3]),
              CardWidget(card: communityCards.cards[4]),
            ],
          ),
          Divider(height: 15),
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

  Widget BetWidget()
  {
    switch(communityCards.cards.length)
    {
      case 0:
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
                  ],
                ),
                numberBox("Minimum Bet: ${maximumBet-players[playerTurn].totalBet}", betAmount),

                Text("Your Chip Total: ${players[playerTurn].chips}"),

                BetButtons(maximumBet-players[playerTurn].totalBet),// BetButtons()
              ]
          );
        }
        break;
      case 3:
        {
          return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Community Cards:"),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CardWidget(card: communityCards.cards[0]),
                    CardWidget(card: communityCards.cards[1]),
                    CardWidget(card: communityCards.cards[2]),
                  ],
                ),

                Text("Total Pot: $pot"),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CardWidget(card: players[playerTurn].hand.cards[0]),
                    CardWidget(card: players[playerTurn].hand.cards[1]),
                  ],
                ),
                numberBox("Minimum Bet: ${maximumBet-players[playerTurn].totalBet}", betAmount),

                Text("Your Chip Total: ${players[playerTurn].chips}"),

                BetButtons(maximumBet-players[playerTurn].totalBet),// BetButtons()
              ]
          );
        }
        break;
      case 4:
        {
          return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Community Cards:"),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CardWidget(card: communityCards.cards[0]),
                    CardWidget(card: communityCards.cards[1]),
                    CardWidget(card: communityCards.cards[2]),
                    CardWidget(card: communityCards.cards[3]),
                  ],
                ),

                Text("Total Pot: $pot"),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CardWidget(card: players[playerTurn].hand.cards[0]),
                    CardWidget(card: players[playerTurn].hand.cards[1]),
                  ],
                ),
                numberBox("Minimum Bet: ${maximumBet-players[playerTurn].totalBet}", betAmount),

                Text("Your Chip Total: ${players[playerTurn].chips}"),

                BetButtons(maximumBet-players[playerTurn].totalBet),// BetButtons()
              ]
          );
        }
        break;
      case 5:
        {
          return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Community Cards:"),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CardWidget(card: communityCards.cards[0]),
                    CardWidget(card: communityCards.cards[1]),
                    CardWidget(card: communityCards.cards[2]),
                    CardWidget(card: communityCards.cards[3]),
                    CardWidget(card: communityCards.cards[4]),
                  ],
                ),

                Text("Total Pot: $pot"),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CardWidget(card: players[playerTurn].hand.cards[0]),
                    CardWidget(card: players[playerTurn].hand.cards[1]),
                  ],
                ),
                numberBox("Minimum Bet: ${maximumBet-players[playerTurn].totalBet}", betAmount),

                Text("Your Chip Total: ${players[playerTurn].chips}"),

                BetButtons(maximumBet-players[playerTurn].totalBet),// BetButtons()
              ]
          );
        }
    }

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
              playerTurn = 0;


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
            });
          },
        ),
        RaisedButton(
          padding: new EdgeInsets.all(10.0),
          child: Text('Bet',
          ),

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
                      print("$playerTurn  3  ${players.length}");
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
          print("Password Screen");
          return enterPassword();
        }
      case 2:
        {
          return betPhase();
        }
        break;
      case 3:
        {
          return dealCommCard(3);
        }
        break;
      case 4:
        {
          return betPhase();
        }
        break;
      case 5:
        {
          return dealCommCard(1);
        }
        break;
      case 6:
        {
          return betPhase();
        }
        break;
      case 7:
        {
          return dealCommCard(1);
        }
        break;
      case 8:
        {
          return betPhase();
        }
        break;
      case 9:
        {
          return winnerPhase();
        }

    }
  }
}

