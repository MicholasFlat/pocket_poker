import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_poker/deck.dart';
import 'main_menu.dart';
import 'set_players.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget
{


  @override
  Widget build(BuildContext context)
  {
    bool singlePhoneMode = true;

    if(singlePhoneMode)
      {
        return new MaterialApp(
          debugShowCheckedModeBanner: false,
          title:"Welcome to Pocket Pocker!",
          theme: ThemeData(primarySwatch: Colors.green),
          initialRoute: '/',
          routes: {
            '/': (context) => SingleHome(),
          },
        );
      }
    else
    return new MaterialApp(
      title: "Welcome to Pocket Poker!",
      theme: ThemeData(primarySwatch: Colors.green,),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/host': (context) => HostScreen(),
        '/join': (context) => JoinScreen(),
        '/spectate': (context) => SpectateScreen(),
      },
    );
  }
}

class SingleHome extends StatelessWidget
{
  final TextEditingController numPlayers= new TextEditingController();

  @override
  Widget build(BuildContext context)
  {

    String usersHint = 'Enter number of users (2-6)';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Poker Poker!'),
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
            child: numberBox(usersHint, numPlayers),
          ),
          RaisedButton(
            padding: new EdgeInsets.all(40.0),
            child: Text('Play Texas Hold Em',),
            onPressed: () {
              if(isNum(numPlayers.text))
                {
                  if(int.parse(numPlayers.text) > 1 && int.parse(numPlayers.text) < 7)
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetUsers(
                                gamemode: 0,
                                userNum: int.parse(numPlayers.text),
                                playerNum: 1,
                                players: <Player>[],
                              )
                          )
                      );
                    }
                  else
                    {
                      numPlayers.clear();
                    }
                }
              else
                {
                  numPlayers.clear();
                }
            },
          ),
          RaisedButton(
            padding: new EdgeInsets.all(40.0),
            child: Text('Play Five Card Draw',
            ),

            onPressed: () {
              if(isNum(numPlayers.text))
              {
                if(int.parse(numPlayers.text) > 1 && int.parse(numPlayers.text) < 7)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetUsers(
                            gamemode: 1,
                            userNum: int.parse(numPlayers.text),
                            playerNum: 1,
                            players: <Player>[],
                          )
                      )
                  );
                }
                else
                {
                  numPlayers.clear();
                }
              }
              else
              {
                numPlayers.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}


 Widget numberBox(String hintText, TextEditingController thiscontroller)
  {
    return new IconTheme(
      data: new IconThemeData(color: Colors.red),
      child: new Container(
        margin: EdgeInsets.all(20.0,),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration:
                new InputDecoration.collapsed(hintText: hintText),
                controller: thiscontroller,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget textBox(String hintText, TextEditingController thiscontroller)
  {
    return new IconTheme(
      data: new IconThemeData(color: Colors.red),
      child: new Container(
        margin: EdgeInsets.all(20.0,),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(hintText: hintText),
                controller: thiscontroller,
                //onSubmitted: _handleSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }

 bool isNum(String string)
  {
    for(int i = 0; i < string.length; i++)
    {
      print(string[i].codeUnitAt(0));
      if(string[i].codeUnitAt(0) < 48 || string[i].codeUnitAt(0) > 57)
      {
        return false;
      }
    }

    return true;
  }

 bool isText(String string)
  {
    for(int i = 0; i < string.length; i++)
    {
      print(string[i].codeUnitAt(0));
      if(string[i].codeUnitAt(0) < 48 || string[i].codeUnitAt(0) > 57)
      {
        if(string[i].codeUnitAt(0) < 65 || string[i].codeUnitAt(0) > 90)
        {
          if(string[i].codeUnitAt(0) < 97 || string[i].codeUnitAt(0) > 122)
          {
            return false;
          }
        }
      }
    }

    return true;
  }

class Player
{
  final String userName;
  final String password;
  Deck hand;
  int chips;
  int totalBet;
  bool fold;
  Player({this.userName, this.password, this.hand, this.chips});
}

