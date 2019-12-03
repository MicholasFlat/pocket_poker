import 'package:flutter/material.dart';
import 'main.dart';
import 'five_card_draw.dart';
import 'texas_hold_em.dart';


class SetUsers extends StatefulWidget
{

  final int gamemode;
  final int userNum;
  final int playerNum;
  List<Player> players;
  SetUsers({this.gamemode, this.userNum, this.playerNum, this.players});

  @override
  State<StatefulWidget> createState() => SetUsersState(gamemode: gamemode, userNum: userNum, playerNum: playerNum, players: players);
}

class SetUsersState extends State<SetUsers>
{
  final int gamemode;
  final int userNum;
  int playerNum;
  List<Player> players;
  SetUsersState({this.gamemode, this.userNum, this.playerNum, this.players});

  final TextEditingController username= new TextEditingController();
  final TextEditingController userpass= new TextEditingController();


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter User $playerNum's Username and Password"),
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
            child: textBox("Enter User $playerNum's Username", username),
          ),
          new Container(
            padding: const EdgeInsets.symmetric(horizontal:25.0),
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: textBox("Enter User $playerNum's Password", userpass),
          ),
          RaisedButton(
            padding: new EdgeInsets.all(40.0),
            child: Text('Next Player',
            ),

            onPressed: () {
              if(isText(username.text) && isText(userpass.text))
                {
                  players.add(new Player(userName: username.text, password: userpass.text, chips: 10000));

                  if(userNum > playerNum)
                    {
                      setState(() {
                        playerNum++;
                        username.clear();
                        userpass.clear();
                      });
                    }
                  else
                    {
                      for(int i = 0; i  <players.length; i++)
                      {
                        print(players[i].userName);
                        print(players[i].password);
                        print("${players[i].chips}");
                      }

                      if(gamemode == 0)
                        {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context)=> THEPoker(players: players)
                          ));
                        }
                      if(gamemode == 1)
                        {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context)=> FCDPoker(players: players)
                          ));
                        }
                    }
                }
              else
                {
                  username.clear();
                  userpass.clear();
                }
            },
          ),
        ],
      ),
    );
  }
}


