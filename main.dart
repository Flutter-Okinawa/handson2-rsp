import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

// ぐー、ちょき、ぱー
enum GTyokPer { g, t, p }

// Playerがほげほげ
enum Result { win, lose, draw }

Result judgement(GTyokPer p1, GTyokPer p2) {
  // ぐー vs ちょき
  if (p1 == GTyokPer.g && p2 == GTyokPer.t) {
    return Result.win;
  }

  // ぐー vs ぱー
  if (p1 == GTyokPer.g && p2 == GTyokPer.p) {
    return Result.lose;
  }

  // ちょき vs ぐー
  if (p1 == GTyokPer.t && p2 == GTyokPer.g) {
    return Result.lose;
  }

  // ちょき　vs ぱー
  if (p1 == GTyokPer.t && p2 == GTyokPer.p) {
    return Result.lose;
  }

  // ぱー vs ぐー
  if (p1 == GTyokPer.p && p2 == GTyokPer.g) {
    return Result.win;
  }

  // ぱー vs ちょき
  if (p1 == GTyokPer.p && p2 == GTyokPer.t) {
    return Result.lose;
  }

  return Result.draw;
}

// Player（人間）vs NPC（こんぴゅーた）がじゃんけんし、結果を表示したい
class Human {
  GTyokPer hand = GTyokPer.g;

  void setHand(GTyokPer hand) => this.hand = hand;

  GTyokPer pon() => this.hand;
}

class NPC {
  GTyokPer hand = GTyokPer.g;
  GTyokPer pon() => this.hand;
}

class Controller {
  Human player1;
  NPC player2;
  List<Result> score = [];

  Controller(this.player1, this.player2);

  play() {
    // player1とplayer2の手を取得して結果を出す
    final h1 = this.player1.pon();
    final h2 = this.player2.pon();

    Result result = judgement(h1, h2);

    print("${h1} ${h2} ${result}");

    // 勝負の結果は配列で持ち続けて、
    // あとから勝率を計算できるようにしたい
    score.add(result);
  }

  String getResult() {
    if (this.score.length == 0) {
      return '';
    }
    return this.score.last.toString();
  }
}

// Player（人間）からはボタンでどの手を出すか選ぶことができる

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: MyRPSWidget(),
      )),
    );
  }
}

class MyRPSWidget extends StatefulWidget {
  MyRPSWidget({Key? key}) : super(key: key);

  @override
  _MyRPSWidgetState createState() => _MyRPSWidgetState();
}

class _MyRPSWidgetState extends State<MyRPSWidget> {
  late Controller controller;
  String _message = '';

  _MyRPSWidgetState() {
    Human player1 = new Human();
    NPC player2 = new NPC();
    this.controller = new Controller(player1, player2);
  }

  void onPressed(GTyokPer hand) {
    this.controller.player1.setHand(hand);
    this.controller.play();
    
    setState(() {
      _message = this.controller.getResult();
    });    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(
        'じゃんけんぽん',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      Text("結果: ${_message}"),
      Padding(
        padding: EdgeInsets.all(100),
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => onPressed(GTyokPer.g),
              child: Text('ぐー'),
            ),
            ElevatedButton(
              onPressed: () => onPressed(GTyokPer.t),
              child: Text('ちょき'),
            ),
            ElevatedButton(
              onPressed: () => onPressed(GTyokPer.p),
              child: Text('ぱー'),
            ),
          ],
        ),
      ),
    ]));
  }
}

