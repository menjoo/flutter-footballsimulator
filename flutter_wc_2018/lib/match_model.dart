import 'package:flutter/material.dart';
import 'simulator.dart';
import 'dart:async';

class MatchModelWidget extends StatefulWidget {
  MatchModelWidget({this.child, this.teamA, this.teamB});

  final Widget child;
  final Team teamA;
  final Team teamB;

  @override
  State<StatefulWidget> createState() {
    return new MatchModelState();
  }

}

class MatchModelState extends State<MatchModelWidget> {

  Game game;
  StreamSubscription streamSubscription;
  List<Event> events;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  startGame() {
    events = new List();
    game = new Game.start(widget.teamA, widget.teamB);

    streamSubscription = game.gameEvent.listen((Event event) {
//      if(event.event == EventType.TimerTick) {
//        print("${event.minute}. ${event.state}");
//      } else {
//        print("${event.minute}. ${event.state} ${event.event} ${event.team?.name}");
//      }
    setState(() {
      events.add(event);
    });

    });
  }

  @override
  Widget build(BuildContext context) {
    return MatchModel(child: widget.child, model: this);
  }
}

class MatchModel extends InheritedWidget {

  MatchModel({this.model, this.child}):super(child:child);

  final MatchModelState model;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static MatchModel of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(MatchModel);
  }
}
