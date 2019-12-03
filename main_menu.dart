import 'package:flutter/material.dart';
import 'main.dart';



class HomeScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Pocket Poker'),
        ),
        body: Center(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <RaisedButton>[
                RaisedButton(
                  padding: new EdgeInsets.all(40.0),
                  child: Text('Host Game', style: TextStyle(fontSize: 40.0),),

                  onPressed: () {
                    Navigator.pushNamed(context, '/host');
                  },
                ),
                RaisedButton(
                  padding: new EdgeInsets.all(40.0),
                  child: Text('Join Game', style: TextStyle(fontSize: 40.0),),
                  onPressed: () {
                    Navigator.pushNamed(context, '/join');
                  },
                ),
                RaisedButton(
                  padding: new EdgeInsets.all(40.0),
                  child: Text('Spectate Game', style: TextStyle(fontSize: 40.0),),
                  onPressed: () {
                    Navigator.pushNamed(context, '/spectate');
                  },
                ),
              ],
            )
        )
    );
  }
}

class HostScreen extends StatefulWidget
{
  @override
  State createState()=> new HostScreenState();
}

class HostScreenState extends State<HostScreen>
{
  final TextEditingController serverName = new TextEditingController();
  final TextEditingController serverPass= new TextEditingController();
  final TextEditingController userName= new TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    String serverhint = 'Enter Server Name (0-9, A-Z, a-z)';
    String passhint = 'Enter Server Password (0-9, A-Z, a-z)';
    String userhint = 'Enter Username (0-9, A-Z, a-z)';

    return Scaffold(
      appBar: AppBar(
        title: Text('Host a Table'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.symmetric(horizontal:25.0),
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: textBox(userhint, userName),
          ),
          new Container(
            margin: const EdgeInsets.symmetric(horizontal:25.0),
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: textBox(serverhint, serverName),
          ),
          new Container(
            margin: const EdgeInsets.symmetric(horizontal:25.0),
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: textBox(passhint, serverPass),
          ),
          new Container(
            margin: const EdgeInsets.symmetric(horizontal:150.0),
            color: Colors.green,
            child: new IconButton(
                icon: new Icon(Icons.add),
                onPressed: ()
                {
                  if(isText(serverName.text) && isText(userName.text) && isText(serverPass.text))
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>Table(
                              state: 0,
                              userName: userName.text,
                              serverName: serverName.text,
                              serverPass: serverPass.text,
                            )
                        )
                    );
                  }
                }
            ),
          )
        ],
      ),
    );
  }
}

class JoinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Game"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack.
            Navigator.pop(context);
          },
          child: Text('NOIPE!'),
        ),
      ),
    );
  }
}

class SpectateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spectate Game"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack.
            Navigator.pop(context);
          },
          child: Text('ASDFASDFASD!'),
        ),
      ),
    );
  }
}



class Table extends StatefulWidget
{
  final int state;
  final String userName;
  final String serverName;
  final String serverPass;
  Table({this.state, this.userName, this.serverName, this.serverPass});

  @override
  State createState()=> selectTable();

  State<Table> selectTable()
  {
    switch(state)
    {
      case 0:
        {
          List<Player> players = <Player>[];
          players.add(Player(userName: userName));


          return new HostTable(
            players: players,
            serverName: serverName,
            serverPass: serverPass,
          );
        }
        break;
      case 1:
        {
          List<Player> players = <Player>[];
          players.add(Player(userName: userName));

          return new PlayerTable(
              players: players,
              serverName: serverName,
              serverPass: serverPass);
        }
        break;
    }
  }
}

class HostTable extends State<Table>
{
  final List<Player> players;
  final String serverName;
  final String serverPass;
  HostTable({this.players, this.serverName, this.serverPass});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      appBar: AppBar(
        title: Text('Table ' + serverName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            child: Text('Play Five Card Draw'),
            onPressed: null,
          ),
          RaisedButton(
            child: Text("Play Texas Hold 'Em"),
            onPressed: null,
          ),
        ],
      ),

    );
  }
}

class PlayerTable extends State<Table>
{
  final String serverName;
  final String serverPass;
  final List<Player> players;
  PlayerTable({this.serverName, this.serverPass, this.players});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

    );
  }
}

class SpectatorTable extends Table
{

}



Color hexToColor(String code)
{
  return Color(int.parse(code.substring(0,6), radix: 16) + 0xFF000000);
}
