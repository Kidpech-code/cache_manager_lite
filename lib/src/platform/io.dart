/// IO platform implementation
library;

import 'package:hive_flutter/hive_flutter.dart';

/// Initialize Hive storage for IO platforms
Future<void> initializeStorage() async {
  await Hive.initFlutter();
}

/// Get Hive box for IO platforms
Future<Box<T>> getBox<T>(String name) async {
  return await Hive.openBox<T>(name);
}

/// Close Hive storage for IO platforms
Future<void> closeStorage() async {
  await Hive.close();
}
