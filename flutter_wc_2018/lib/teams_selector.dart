import 'package:flutter/material.dart';
import 'dart:async';
import 'simulator.dart';
import 'match.dart';
import 'match_model.dart';

class SelectTeamsPage extends StatefulWidget {
  SelectTeamsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<SelectTeamsPage> {

  List<Team> countries = [
    new Team(name: "NED", flagCode: "nl", strength: 70),
    new Team(name: "GER", flagCode: "de", strength: 90),
    new Team(name: "FRA", flagCode: "fr", strength: 85),
    new Team(name: "ESP", flagCode: "es", strength: 85)
  ];

  Team _selectedTeamA;
  Team _selectedTeamB;

  @override
  Widget build(BuildContext context) {
    _selectedTeamA = countries[0];
    _selectedTeamB = countries[countries.length - 1];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.white30,
          hasNotch: true,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.info), color: Colors.black45, onPressed: () {
                _showInfoDialog();
              }),
            ],
          ),
      ),
      body: Container(
        decoration: new BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/field.jpg")
            )
        ),
        child: Stack(children: <Widget>[
          new Center(
            child: new Container(
                width: 60.0,
                height: 80.0,
                child: new Image.asset("assets/images/versus.png")
            ),
          ),
          new Column(
            children: <Widget>[
              new TeamSelector(
                  countries: _getCountriesForSelector(),
                  onSelectionChanged: (Team team) {
                    _selectedTeamA = team;
                    print("team A set to ${team.name}");
              }),
              new TeamSelector(
                  countries: _getCountriesForSelector(moveFirst: true),
                  onSelectionChanged: (Team team) {
                    _selectedTeamB = team;
                    print("team B set to ${team.name}");
              })
            ],
          ),
        ],)
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          Navigator.push(context, new MaterialPageRoute(builder: (context) =>
            new MatchModelWidget(
                child: new MatchPage(
                    teamA: _selectedTeamA,
                    teamB:_selectedTeamB,
                ),
              teamA: _selectedTeamA,
              teamB:_selectedTeamB,
            )
          ),
          );
        },
        tooltip: 'Start match',
        child: Padding(padding: EdgeInsets.all(20.0), child: new Image.asset("assets/images/ball.png")),
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.centerDocked,// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<Null> _showInfoDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('World Cup 2018 Simulator'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('This app is build with Flutter.'),
                new Text('It only took two days, it\'s amazing!'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Applause'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Iterable _getCountriesForSelector({moveFirst: false}) {
    List<Team> list = new List.from(this.countries);
    if(moveFirst) {
      list.insert(0, list.removeLast());
      return list;
    }
    return list;
  }
}

class TeamSelector extends StatelessWidget {
  const TeamSelector({
    Key key,
    @required this.countries,
    @required this.onSelectionChanged
  }) : super(key: key);

  final List<Team> countries;
  final Function onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: PageView.builder(
        itemCount: countries.length,
        onPageChanged: (int index) {
          print("selected ${countries[index].name}");
          onSelectionChanged(countries[index]);
        },
        itemBuilder: (BuildContext context, int index) {
      return Container(
          child: Center(
            child: Container(
              width: 150.0,
              height: 100.0,
              child: new Image.network("http://flags.fmcdn.net/data/flags/w580/${countries[index].flagCode}.png")
            )
          )
      );
    }),
    );
  }
}
