/// IO platform implementation
library;

import 'package:hive/hive.dart';

/// Initialize Hive storage for IO platforms
Future<void> initializeStorage() async {
  // For IO platforms, Hive will automatically use appropriate storage location
  // No explicit initialization needed - Hive handles platform-specific paths
}

/// Get Hive box for IO platforms
Future<Box<T>> getBox<T>(String name) async {
  return await Hive.openBox<T>(name);
}

/// Close Hive storage for IO platforms
Future<void> closeStorage() async {
  await Hive.close();
}
