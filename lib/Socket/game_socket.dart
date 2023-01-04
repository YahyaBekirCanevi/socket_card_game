// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class Player {
  String? id;
  final String name;
  List<String> messages;
  List<String> hand;
  double points;

  Player({
    this.id,
    required this.name,
    this.messages = const [],
    this.hand = const [],
    this.points = 0,
  });

  static Player fromJson(Map json) => Player(
        id: json['id'],
        name: json['name'],
        messages: json['messages'],
        hand: json['hand'],
        points: json['points'],
      );
}

class GameState {
  bool started;
  List<String> deck;
  List<Player> players;
  String turn;
  String winner;

  GameState({
    this.started = false,
    this.deck = const [],
    this.players = const [],
    this.turn = '',
    this.winner = '',
  });

  static GameState fromJson(Map json) => GameState(
        started: json['started'],
        deck: json['deck'],
        players: json['players'],
        turn: json['turn'],
        winner: json['winner'],
      );
}

class GameSocketProvider extends ChangeNotifier {
  late io.Socket socket;
  String roomId = "";
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
      print("room_update $data");
      roomId = data['id'];
      roomName = data['name'];
      notifyListeners();
    });

    // Listen for game state updates
    socket.on('game_state', (data) {
      print("room_update $data");
      gameState = data;
      notifyListeners();
    });
  }

  disconnect() {
    print("disconnect $roomId");
    socket.emit('disconnect');
    socket.disconnect();
  }

  bool isJoined() => gameState.players.any((e) => e.name == playerName);

  joinGame(String playerName) {
    print("joinGame $playerName $roomId");
    this.playerName = playerName;
    socket.emit('join_game', playerName);
    notifyListeners();
  }

  startGame() {
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
  }
}
