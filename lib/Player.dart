class Player {
  String name;
  String role; // 役職 (村人, 狼, 占い師など)
  bool isAlive;

  Player(this.name, this.role) : isAlive = true;
}
