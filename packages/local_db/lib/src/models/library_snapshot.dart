/// Lightweight counts so Home can prove the seed without money UI.
final class LibrarySnapshot {
  const LibrarySnapshot({
    required this.partyCount,
    required this.moneyCount,
    required this.openMoneyCount,
    required this.reminderCount,
    required this.noteCount,
  });

  final int partyCount;
  final int moneyCount;
  final int openMoneyCount;
  final int reminderCount;
  final int noteCount;
}
