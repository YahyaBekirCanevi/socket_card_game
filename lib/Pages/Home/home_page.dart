import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:socket_card_game/Socket/game_socket.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameSocketProvider>();
    final playerNameController = useTextEditingController();
    final roomIdController = useTextEditingController();

    join() {
      gameProvider.joinGame(
        roomId: roomIdController.text.isEmpty ? null : roomIdController.text,
        playerName: playerNameController.text,
      );
    }

    disconnect() {
      gameProvider.disconnect();
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
            InkWell(
              onTap: () => Clipboard.setData(
                ClipboardData(text: "${gameProvider.roomId}"),
              ),
              child: Text(
                "${gameProvider.roomId}",
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              gameProvider.roomName,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ...(gameProvider.isJoined
                ? List.generate(
                    gameProvider.gameState.players?.length ?? 0,
                    (i) => Container(
                      height: 60,
                      width: 200,
                      color: Colors.amber[50],
                      child: Center(
                        child: Text(
                          gameProvider.gameState.players?[i].name ?? "",
                        ),
                      ),
                    ),
                  )
                : [
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 400, minWidth: 200),
                      child: TextField(
                        controller: playerNameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter player name',
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 400, minWidth: 200),
                      child: TextField(
                        controller: roomIdController,
                        decoration: const InputDecoration(
                          hintText: 'Enter RoomID',
                        ),
                      ),
                    )
                  ]),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: gameProvider.isJoined ? disconnect : join,
              child: Text(
                '${gameProvider.isJoined ? "Disconnect" : "Join"} game',
              ),
            )
          ],
        ),
      ),
    );
  }
}
