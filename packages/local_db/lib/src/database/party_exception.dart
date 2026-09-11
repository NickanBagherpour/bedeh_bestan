enum PartyFailure { inUse, missing }

final class PartyException implements Exception {
  const PartyException(this.failure);

  final PartyFailure failure;

  @override
  String toString() => 'PartyException($failure)';
}

final class PartyUsage {
  const PartyUsage({required this.moneyCount, required this.noteCount});

  final int moneyCount;
  final int noteCount;

  bool get isEmpty => moneyCount == 0 && noteCount == 0;
}
