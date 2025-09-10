/// Platform-specific imports for WASM compatibility
library;

import 'package:hive/hive.dart';
import 'stub.dart' if (dart.library.io) 'io.dart' if (dart.library.html) 'web.dart';

/// Initialize platform-specific storage
Future<void> initializePlatformStorage() async {
  await initializeStorage();
}

/// Get platform-appropriate box
Future<Box<T>> getPlatformBox<T>(String name) async {
  return await getBox<T>(name);
}

/// Close platform storage
Future<void> closePlatformStorage() async {
  await closeStorage();
}
