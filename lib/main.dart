import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_card_game/Pages/Home/home_page.dart';
import 'package:socket_card_game/Socket/game_socket.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Card Game',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(146, 194, 217, 255),
      ),
      home: ChangeNotifierProvider(
        create: (_) => GameSocketProvider(),
        child: const HomePage(),
      ),
    );
  }
}
