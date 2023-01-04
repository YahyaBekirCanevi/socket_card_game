import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:socket_card_game/Socket/game_socket.dart';

class LobbyPage extends HookWidget {
  const LobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameSocketProvider>(
        builder: (context, gameProvider, _) {
          if (gameProvider.isJoined()) {
            return const Center(child: Text('Waiting for game to start'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                gameProvider.roomName,
                style: const TextStyle(color: Colors.white, fontSize: 36),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: gameProvider.gameState.players.length,
                  itemBuilder: (context, i) => Text(
                    gameProvider.gameState.players[i].name,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => gameProvider.startGame(),
                    child: const Text('Start game'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      gameProvider.disconnect();
                      Navigator.pop(context);
                    },
                    child: const Text('Disconnect'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
