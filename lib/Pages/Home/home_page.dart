import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:socket_card_game/Pages/Lobby/lobby_page.dart';
import 'package:socket_card_game/Socket/game_socket.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameSocketProvider>();
    final playerNameController = useTextEditingController();

    join() {
      gameProvider.joinGame(playerNameController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: gameProvider,
            child: const LobbyPage(),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Card Game',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400, minWidth: 200),
              child: TextField(
                controller: playerNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter player name',
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: join,
              child: const Text('Join game'),
            ),
          ],
        ),
      ),
    );
  }
}
