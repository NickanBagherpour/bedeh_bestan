import 'package:drift/native.dart';

import 'src/database/app_database.dart';

/// In-memory SQLite for tests (VM / desktop). Do not import from app `lib/`.
AppDatabase openMemoryDatabase() => AppDatabase(NativeDatabase.memory());
