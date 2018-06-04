import 'package:flutter/material.dart';
import 'simulator.dart';
import 'match_model.dart';

class MatchPage extends StatelessWidget {

  MatchPage({this.teamA, this.teamB});

  final Team teamA;
  final Team teamB;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("${teamA.name} - ${teamB.name}"),
      ),
      body: Column(
        children: <Widget>[
          ScoreBoard(teamA: this.teamA.flagCode, teamB: teamB.flagCode),
          new EventList()
        ],
      ),
    );
  }
}

class ScoreBoard extends StatelessWidget {

  ScoreBoard({this.teamA, this.teamB});

  final String teamA;
  final String teamB;

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/field_horizontal.jpg"),
              fit: BoxFit.fill
          )
      ),
      height: 200.0,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Container(
              width: 50.0,
              height: 35.0,
              child: new Image.network("http://flags.fmcdn.net/data/flags/w580/$teamA.png"),
            ),
          ),
          Expanded(child: Container()),
          Center(
            child: Text("0   -   0",
                style: TextStyle(color: Colors.white, fontSize: 60.0)
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Container(
              width: 50.0,
              height: 35.0,
              child: new Image.network("http://flags.fmcdn.net/data/flags/w580/$teamB.png"),
            ),
          ),
        ],
      ),
    );
  }
}

class EventList extends StatelessWidget {
  const EventList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          child: new ListView.builder(
            itemBuilder: (BuildContext context, int index) => EventRow(event: MatchModel.of(context).model.events[index]),
            itemCount: MatchModel.of(context).model.events.length,
          ),
        ),
    );
  }
}

class EventRow extends StatelessWidget {
  EventRow({this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Padding(
            padding: new EdgeInsets.only(left: 5.0),
            child: Container(
              child: new Image.asset("assets/images/${getIconForEvent(event.event)}.png"),
              width: 5.0,
              height: 5.0,
            ),
          ),
          Expanded(child: Container()),
          Text("'${event.minute} ${event.event}"),
          Expanded(child: Container()),
          Padding(
            padding: new EdgeInsets.only(right:  5.0),
            child: Container(
              color: Colors.amber,
              width: 5.0,
              height: 5.0,
            ),
          )
        ],
      )
    );
  }

  getIconForEvent(EventType event) {
    switch(event) {
      case EventType.Goal: return "ball";
      case EventType.Corner: return "corner";
      case EventType.Miss: return "";
      case EventType.FreeKick: return "injury";
      case EventType.Substitude: return "sub";
      case EventType.YellowCard: return "card_yellow";
      case EventType.RedCard: return "card_red";
    }

  }
}
