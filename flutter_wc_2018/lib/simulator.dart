import 'dart:async';
import 'dart:math';
import 'dart:core';

class Team {
  String name;
  String flagCode;
  int strength;
  Team({this.name, this.flagCode, this.strength});
}

enum EventType { Goal, Miss, Corner, RedCard, YellowCard, FreeKick, Substitude, TimerTick }

enum GameState { NotStarted, Started, Paused, Ended }

class Event {
  EventType event;
  GameState state;
  int minute;
  Team team;
  Event({this.event, this.state, this.minute, this.team});
}

class Game {
  GameState state = GameState.NotStarted;
  int minute = 0;
  Team teamA;
  Team teamB;

  StreamController<Event> eventController;

  Stream<Event> get gameEvent {
    return eventController.stream;
  }

  Game.start(Team teamA, Team teamB) {
    this.teamA = teamA;
    this.teamB = teamB;
    eventController = new StreamController.broadcast();
    minute = 0;
    eventController.add(new Event(event: EventType.TimerTick, state: state, minute: minute, team: null));

    new Timer.periodic(new Duration(milliseconds: 200), (Timer timer) {
      state = (minute > 45 && minute < 60) ? GameState.Paused : GameState.Started;
      if (minute == 105) {
        timer.cancel();
        eventController.add(new Event(event: EventType.TimerTick, state: state, minute: minute, team: null));
        eventController.close();
      } else {
        calcEvent(minute);
      }
    });
  }

  calcEvent(int minute) {
    this.minute++;
    Team team = new Random().nextInt(2) == 0 ? teamA : teamB;

    if (eventHappens()) {
      EventType eventType = getRandomEvent();
      if(eventType == EventType.Goal) {
        handleGoal(minute, team);
      } else {
        handleEvent(eventType, minute, team);
      }
    } else {
      handleTick(minute);
    }
  }

  bool eventHappens() {
    return new Random().nextInt(100) % (minute < 15 || minute > 75 ? 2 : 4) == 0 && state == GameState.Started;
  }

  void handleGoal(int minute, Team team) {
    int diff = (teamA.strength - teamB.strength).abs();
    bool goal = true; //TODO use diff
    if(goal) {
      eventController.add(new Event(event: EventType.Goal, state: state, minute: minute, team: team));
    }
  }

  void handleEvent(EventType eventType, int minute, Team team) {
    eventController.add(new Event(event: eventType, state: state, minute: minute, team: team));
  }

  void handleTick(int minute) {
    eventController.add(new Event(event: EventType.TimerTick, state: state, minute: minute, team: null));
  }

  EventType getRandomEvent() {
    int rnd = new Random().nextInt(EventType.values.length - 1);
    return EventType.values[rnd];
  }
}

main() {
  Game game = new Game.start(new Team(name: "NL", flagCode: "nl", strength: 78), new Team(name: "DE", flagCode: "de", strength: 88));
  game.gameEvent.listen((Event event) {
    if(event.event == EventType.TimerTick) {
      print("${event.minute}. ${event.state}");
    } else {
      print("${event.minute}. ${event.state} ${event.event} ${event.team?.name}");
    }
  });
}
