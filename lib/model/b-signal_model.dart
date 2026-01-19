//Bsignal で表示する仮データのモデル

class EncounterUser {
  final int id;
  final String name;
  bool isCelebrated;

  EncounterUser({
    required this.id,
    required this.name,
    this.isCelebrated = false,
  });
}
