import 'player.dart';
import 'dart:math';

class Game {
  List<Player> players = [];
  int day = 1;

  Game(List<String> playerNames) {
    assignRoles(playerNames);
  }

  void assignRoles(List<String> playerNames) {
    List<String> roles = List.filled(playerNames.length - 2, "村人") +
        ["狼", "占い師"]; // 役職の設定
    roles.shuffle(Random());

    for (int i = 0; i < playerNames.length; i++) {
      players.add(Player(playerNames[i], roles[i]));
    }
  }

  void vote(String playerName) {
    // 投票処理を実装
  }

  void nightActions() {
    // 夜のアクション処理を実装
  }

  bool checkVictory() {
    // 勝利条件のチェックを実装
    return false; // 例
  }
}
