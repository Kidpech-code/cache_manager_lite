/// Web platform implementation for WASM compatibility
library;

import 'package:hive/hive.dart';

/// Initialize Hive storage for Web/WASM platforms
Future<void> initializeStorage() async {
  // For web, Hive doesn't need Flutter-specific initialization
  // Just ensure Hive is ready to use
}

/// Get Hive box for Web/WASM platforms
Future<Box<T>> getBox<T>(String name) async {
  return await Hive.openBox<T>(name);
}

/// Close Hive storage for Web/WASM platforms
Future<void> closeStorage() async {
  await Hive.close();
}
