// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class Card {
  String? suit;
  String? value;

  Card({this.suit, this.value});

  Card.fromJson(Map json) {
    suit = json['suit'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() => {
        "suit": suit,
        "value": value,
      };
}

class Player {
  String? id;
  String? name;
  List<String>? messages;
  List<String>? hand;
  double? points;

  Player({
    this.id,
    this.name,
    this.messages = const [],
    this.hand = const [],
    this.points = 0,
  });

  Player.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    messages = List<String>.from(json['messages']);
    hand = List<String>.from(json['hand']);
    points = json['points'];
  }
}

class GameState {
  bool? started;
  List<String>? deck;
  List<Player>? players;
  String? turn;
  String? winner;

  GameState({
    this.started = false,
    this.deck = const [],
    this.players = const [],
    this.turn = '',
    this.winner = '',
  });

  GameState.fromJson(Map json) {
    started = json['started'];
    deck = List<String>.from(json['deck']);
    if (json['players'] != null) {
      List<Player> list = [];
      json['players'].forEach((e) => list.add(Player.fromJson(e)));
      players = list;
    }
    turn = json['turn'];
    winner = json['winner'];
  }
}

class Room {
  String? name;
  List<String>? users;

  Room({this.name, this.users});

  Room.fromJson(Map json) {
    name = json['name'];
    users = List<String>.from(json['users']);
  }
}

class GameSocketProvider extends ChangeNotifier {
  late io.Socket socket;
  String? roomId;
  String roomName = "";
  String playerName = "";
  GameState gameState = GameState();

  GameSocketProvider() {
    // Initialize socket
    socket = io.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });
    // Get room Id
    socket.on('room_update', (data) {
      print("room_update");
      roomId = data['id'];
      roomName = data['name'];
      notifyListeners();
    });

    // Listen for game state updates
    socket.on('game_state', (data) {
      print("game_state");
      gameState = GameState.fromJson(data);
      notifyListeners();
    });
  }

  bool get isJoined =>
      gameState.players?.any((e) => e.name == playerName) ?? false;

  joinGame({String? roomId, required String playerName}) {
    print("join $playerName");
    print("RoomID: $roomId");
    this.playerName = playerName;
    this.roomId = roomId;
    socket.emit('join_room', [roomId, playerName]);
    print("joined");
    notifyListeners();
  }

  disconnect() {
    print("disconnect");
    socket.emit('disconnect');
    socket.disconnect();
    gameState = GameState();
    roomId = null;
    roomName = "";
    notifyListeners();
  }

  /*  startGame() {
    print("startGame $roomId");
    socket.emit('start_game');
  }

  endGame() {
    print("endGame $roomId");
    socket.emit('end_game');
  }

  sendMessage(String message) {
    print("sendMessage $message");
    socket.emit('message', message);
  } */

}
