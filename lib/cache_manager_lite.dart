/// A high-performance, user-friendly, and secure cache manager for Flutter.
///
/// This library provides a comprehensive caching solution with support for:
/// - Multiple user skill levels (Beginner to Expert)
/// - Flexible expiration management
/// - Optional AES encryption
/// - Real-time monitoring
/// - Multi-platform support
///
/// ## Quick Start
///
/// ```dart
/// import 'package:cache_manager_lite/cache_manager_lite.dart';
///
/// // Create a cache manager
/// final cacheManager = CacheManagerLite.forBeginner();
///
/// // Store data
/// await cacheManager.putForHours(
///   key: 'user_profile',
///   value: userProfile,
///   hours: 1,
/// );
///
/// // Retrieve data
/// final profile = await cacheManager.get('user_profile');
/// ```
library;

export 'src/domain/entities/cache_config.dart';
export 'src/domain/entities/cache_entry.dart';
export 'src/domain/entities/cache_policy.dart';
export 'src/domain/entities/scalable_cache_config.dart';
import 'package:dio/dio.dart';

import 'src/data/datasources/dio_cache_interceptor.dart';
import 'src/data/datasources/dio_data_source.dart';
import 'src/data/datasources/hive_data_source.dart';
import 'src/data/repositories/hive_cache_repository.dart';
import 'src/domain/entities/cache_config.dart';
import 'src/domain/entities/cache_entry.dart';
import 'src/domain/entities/cache_policy.dart';
import 'src/domain/entities/scalable_cache_config.dart';
import 'src/domain/usecases/clear_cache_use_case.dart';
import 'src/domain/usecases/get_cache_use_case.dart';
import 'src/domain/usecases/put_cache_use_case.dart';
import 'src/utils/encryption_utils.dart' as utils;

/// **CacheManagerLite - ตัวจัดการแคชที่ทรงพลังและใช้งานง่าย**
///
/// คลาสหลักสำหรับการจัดการแคชใน Flutter Application ด้วยความสามารถขั้นสูง
/// รองรับการเข้ารหัส, การหมดอายุแบบยืดหยุ่น, และการตั้งค่าแบบขยายได้
///
/// ## 🎯 การใช้งาน
///
/// CacheManagerLite ถูกออกแบบมาเพื่อจัดการข้อมูลแคชในแอปพลิเคชัน Flutter
/// โดยรองรับการเก็บข้อมูลทั้งในรูปแบบ JSON, Bytes, และ Object ต่างๆ
/// พร้อมด้วยระบบการหมดอายุที่ยืดหยุ่นและการเข้ารหัสข้อมูลที่ปลอดภัย
///
/// ## 🚀 ตัวอย่างการใช้งานพื้นฐาน
///
/// ```dart
/// // เริ่มต้นใช้งานแบบง่าย
/// final cacheManager = CacheManagerLite();
///
/// // เก็บข้อมูลโปรไฟล์ผู้ใช้ หมดอายุใน 1 ชั่วโมง
/// await cacheManager.putForHours(
///   key: 'user_profile',
///   value: userProfileData,
///   hours: 1,
/// );
///
/// // ดึงข้อมูลกลับมา
/// final profile = await cacheManager.get('user_profile');
/// ```
///
/// ## ⚡ ตัวอย่างการใช้งานขั้นสูง
///
/// ```dart
/// // สำหรับแอป E-commerce ขนาดใหญ่
/// final cacheManager = CacheManagerLite.forAdvanced(
///   appType: AppType.ecommerce,
///   cacheSize: CacheSize.large,
///   performanceLevel: PerformanceLevel.high,
///   enableEncryption: true,
///   encryptionKey: 'my-secret-key-2024',
/// );
///
/// // เก็บข้อมูลสินค้าพร้อมเข้ารหัส หมดอายุเมื่อสิ้นวัน
/// await cacheManager.putUntilEndOfDay(
///   key: 'product_${productId}',
///   value: productData,
///   encryptionKey: 'product-encryption-key',
/// );
/// ```
///
/// ## 🔧 ตัวอย่างการ Custom ทุกอย่าง
///
/// ```dart
/// // การตั้งค่าแบบกำหนดเองสมบูรณ์
/// final customPolicy = CachePolicy.expiresAt(
///   expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
///   encryptionKey: 'ultra-secure-key',
/// );
///
/// final cacheManager = CacheManagerLite.custom(
///   customSizeBytes: 100 * 1024 * 1024, // 100MB
///   customPolicy: customPolicy,
///   appType: AppType.gaming,
///   enableEncryption: true,
///   memoryCacheRatio: 0.3, // ใช้ RAM 30%
/// );
/// ```
///
/// ## 📊 การตรวจสอบสถานะแบบเรียลไทม์
///
/// ```dart
/// // ตรวจสอบข้อมูลแคชละเอียด
/// final info = await cacheManager.getEntryInfo('important_data');
/// if (info != null) {
///   print('สถานะ: ${info.statusDescription}');
///   print('หมดอายุ: ${info.expiresAt}');
///   print('เวลาที่เหลือ: ${info.remainingTime}');
///   print('อายุแคช: ${info.age}');
/// }
///
/// // ขยายเวลาหมดอายุ
/// await cacheManager.extendExpiration(
///   key: 'important_data',
///   additionalTime: Duration(hours: 2),
/// );
/// ```
///
/// ## 🎮 ตัวอย่างการใช้งานใน Gaming App
///
/// ```dart
/// final gameCache = CacheManagerLite.forExpert(
///   cacheSize: CacheSize.large,
///   performanceLevel: PerformanceLevel.ultra,
///   appType: AppType.gaming,
///   enableEncryption: true,
///   memoryCacheRatio: 0.25, // ใช้ RAM 25% สำหรับความเร็ว
/// );
///
/// // เก็บข้อมูลผู้เล่น หมดอายุใน 2 ชั่วโมง
/// await gameCache.putForHours(
///   key: 'player_${playerId}',
///   value: playerStats,
///   hours: 2,
/// );
///
/// // เก็บ Leaderboard รายวัน
/// await gameCache.putUntilEndOfDay(
///   key: 'daily_leaderboard',
///   value: leaderboardData,
/// );
/// ```
class CacheManagerLite {
  /// **การกำหนดค่าแคชแบบมาตรฐาน (customizable)**
  ///
  /// ใช้สำหรับกำหนดค่าพื้นฐานของแคช เช่น ขนาดสูงสุด, นโยบายเริ่มต้น
  ///
  /// **ตัวอย่างการ custom:**
  /// ```dart
  /// final config = CacheConfig(
  ///   maxCacheSize: 50 * 1024 * 1024, // 50MB
  ///   defaultPolicy: CachePolicy.inHours(6), // หมดอายุทุก 6 ชั่วโมง
  /// );
  ///
  /// final cacheManager = CacheManagerLite(config: config);
  /// ```
  final CacheConfig? config;

  /// **การกำหนดค่าแคชแบบขยายได้ (highly customizable)**
  ///
  /// ใช้สำหรับแอปพลิเคชันที่ต้องการการตั้งค่าขั้นสูง รองรับขนาดแอปต่างๆ
  /// และระดับประสิทธิภาพที่แตกต่างกัน
  ///
  /// **ตัวอย่างการ custom:**
  /// ```dart
  /// final scalableConfig = ScalableCacheConfig.forExpert(
  ///   cacheSize: CacheSize.large,
  ///   performanceLevel: PerformanceLevel.ultra,
  ///   appType: AppType.ecommerce,
  ///   customSizeBytes: 200 * 1024 * 1024, // 200MB custom
  ///   enableEncryption: true,
  ///   encryptionKey: 'my-ultra-secure-key-2024',
  ///   memoryCacheRatio: 0.2, // ใช้ RAM 20%
  /// );
  ///
  /// final cacheManager = CacheManagerLite(scalableConfig: scalableConfig);
  /// ```
  final ScalableCacheConfig? scalableConfig;

  // ========================================
  // ตัวแปรภายใน (Internal Variables)
  // ========================================

  /// **ตัวจัดการข้อมูล Hive (ไม่สามารถ custom ได้)**
  ///
  /// ใช้สำหรับการเชื่อมต่อและจัดการฐานข้อมูล Hive NoSQL
  /// ที่เป็นฐานข้อมูลหลักในการเก็บข้อมูลแคช
  late final HiveDataSource _hiveDataSource;

  /// **ตัวจัดการข้อมูล HTTP (ไม่สามารถ custom ได้)**
  ///
  /// ใช้สำหรับการดึงข้อมูลจาก API ผ่าน Dio HTTP Client
  /// พร้อมด้วยระบบแคชอัตโนมัติสำหรับ response
  late final DioDataSource _dioDataSource;

  /// **Repository สำหรับการจัดการแคช (ไม่สามารถ custom ได้)**
  ///
  /// เป็นชั้นกลางระหว่าง Business Logic และ Data Source
  /// ตาม Clean Architecture pattern
  late final HiveCacheRepository _repository;

  /// **Use Case สำหรับการดึงข้อมูล (ไม่สามารถ custom ได้)**
  ///
  /// จัดการ Business Logic ในการดึงข้อมูลจากแคช
  /// รวมถึงการตรวจสอบการหมดอายุ
  late final GetCacheUseCase _getCacheUseCase;

  /// **Use Case สำหรับการเก็บข้อมูล (ไม่สามารถ custom ได้)**
  ///
  /// จัดการ Business Logic ในการเก็บข้อมูลลงแคช
  /// รวมถึงการเข้ารหัสและการตั้งค่าเวลาหมดอายุ
  late final PutCacheUseCase _putCacheUseCase;

  /// **Use Case สำหรับการล้างแคช (ไม่สามารถ custom ได้)**
  ///
  /// จัดการ Business Logic ในการล้างข้อมูลแคชทั้งหมด
  late final ClearCacheUseCase _clearCacheUseCase;

  // ========================================
  // Constructors (ตัวสร้าง)
  // ========================================

  /// **Constructor หลักของ CacheManagerLite**
  ///
  /// สร้าง instance ของ CacheManagerLite ด้วยการกำหนดค่าที่ยืดหยุ่น
  ///
  /// ## พารามิเตอร์ที่สามารถ custom ได้:
  ///
  /// - **[config]**: การกำหนดค่าแบบมาตรฐาน (optional)
  ///   ```dart
  ///   final config = CacheConfig(
  ///     maxCacheSize: 100 * 1024 * 1024, // 100MB
  ///     defaultPolicy: CachePolicy.inHours(4),
  ///   );
  ///   ```
  ///
  /// - **[scalableConfig]**: การกำหนดค่าแบบขยายได้ (optional)
  ///   ```dart
  ///   final scalableConfig = ScalableCacheConfig.forAdvanced(
  ///     appType: AppType.social,
  ///     cacheSize: CacheSize.large,
  ///     performanceLevel: PerformanceLevel.high,
  ///   );
  ///   ```
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // แบบพื้นฐาน (ใช้ค่าเริ่มต้น)
  /// final cacheManager = CacheManagerLite();
  ///
  /// // แบบกำหนดค่าเอง
  /// final cacheManager = CacheManagerLite(
  ///   config: CacheConfig(
  ///     maxCacheSize: 50 * 1024 * 1024,
  ///     defaultPolicy: CachePolicy.inDays(1),
  ///   ),
  /// );
  ///
  /// // แบบขยายได้สำหรับแอปใหญ่
  /// final cacheManager = CacheManagerLite(
  ///   scalableConfig: ScalableCacheConfig.forExpert(
  ///     cacheSize: CacheSize.enterprise,
  ///     performanceLevel: PerformanceLevel.ultra,
  ///     appType: AppType.ecommerce,
  ///   ),
  /// );
  /// ```
  CacheManagerLite({this.config, this.scalableConfig}) {
    _initialize();
  }

  /// **Factory Constructor สำหรับแอปพลิเคชันขนาดเล็ก**
  ///
  /// เหมาะสำหรับ: แอป Utility, Todo App, Calculator, Simple Tools
  ///
  /// ## คุณสมบัติ:
  /// - ขนาดแคช: 10-25MB
  /// - ประสิทธิภาพ: Balanced
  /// - การเข้ารหัส: เลือกได้
  /// - การตั้งค่า: ง่ายและเร็ว
  ///
  /// ## พารามิเตอร์ที่ custom ได้:
  ///
  /// - **[appType]**: ประเภทแอปพลิเคชัน (default: AppType.utility)
  ///   - `AppType.utility` - แอป utility ทั่วไป
  ///   - `AppType.social` - แอป social media
  ///   - `AppType.ecommerce` - แอป e-commerce
  ///   - `AppType.gaming` - แอป gaming
  ///
  /// - **[enableEncryption]**: เปิดใช้การเข้ารหัส (default: false)
  ///   - `true` - เข้ารหัสข้อมูลด้วย AES
  ///   - `false` - ไม่เข้ารหัส (เร็วกว่า)
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // สำหรับแอป Todo ง่ายๆ
  /// final cacheManager = CacheManagerLite.small();
  ///
  /// // สำหรับแอป Social ขนาดเล็กพร้อมเข้ารหัส
  /// final cacheManager = CacheManagerLite.small(
  ///   appType: AppType.social,
  ///   enableEncryption: true,
  /// );
  ///
  /// // เก็บข้อมูลโปรไฟล์
  /// await cacheManager.putForHours(
  ///   key: 'user_profile',
  ///   value: profileData,
  ///   hours: 2,
  /// );
  /// ```
  factory CacheManagerLite.small({
    AppType appType = AppType.utility,
    bool enableEncryption = false,
  }) {
    return CacheManagerLite(
      scalableConfig: ScalableCacheConfig.small(
        appType: appType,
        enableEncryption: enableEncryption,
      ),
    );
  }

  /// **Factory Constructor สำหรับแอปพลิเคชันขนาดกลาง**
  ///
  /// เหมาะสำหรับ: Social Media App, News App, Weather App, Medium-sized Apps
  ///
  /// ## คุณสมบัติ:
  /// - ขนาดแคช: 25-75MB
  /// - ประสิทธิภาพ: High
  /// - การเข้ารหัส: เลือกได้
  /// - Background cleanup: อัตโนมัติ
  ///
  /// ## พารามิเตอร์ที่ custom ได้:
  ///
  /// - **[appType]**: ประเภทแอปพลิเคชัน (default: AppType.social)
  /// - **[enableEncryption]**: เปิดใช้การเข้ารหัส (default: false)
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // สำหรับแอป Social Media
  /// final cacheManager = CacheManagerLite.medium(
  ///   appType: AppType.social,
  ///   enableEncryption: true,
  /// );
  ///
  /// // เก็บโพสต์สำหรับวันนี้
  /// await cacheManager.putUntilEndOfDay(
  ///   key: 'today_posts',
  ///   value: postsData,
  /// );
  ///
  /// // เก็บรูปภาพพร้อมเข้ารหัส
  /// await cacheManager.putForDays(
  ///   key: 'profile_image_$userId',
  ///   value: imageBytes,
  ///   days: 7,
  ///   encryptionKey: 'image-key-2024',
  /// );
  /// ```
  factory CacheManagerLite.medium({
    AppType appType = AppType.social,
    bool enableEncryption = false,
  }) {
    return CacheManagerLite(
      scalableConfig: ScalableCacheConfig.medium(
        appType: appType,
        enableEncryption: enableEncryption,
      ),
    );
  }

  /// **Factory Constructor สำหรับแอปพลิเคชันขนาดใหญ่**
  ///
  /// เหมาะสำหรับ: E-commerce App, Enterprise App, Media Streaming App
  ///
  /// ## คุณสมบัติ:
  /// - ขนาดแคช: 75-200MB
  /// - ประสิทธิภาพ: Ultra High
  /// - การเข้ารหัส: เปิดใช้งานโดยค่าเริ่มต้น
  /// - Background cleanup: ขั้นสูง
  /// - Memory optimization: เปิดใช้งาน
  ///
  /// ## พารามิเตอร์ที่ custom ได้:
  ///
  /// - **[appType]**: ประเภทแอปพลิเคชัน (default: AppType.ecommerce)
  /// - **[enableEncryption]**: เปิดใช้การเข้ารหัส (default: true)
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // สำหรับแอป E-commerce
  /// final cacheManager = CacheManagerLite.large(
  ///   appType: AppType.ecommerce,
  ///   enableEncryption: true,
  /// );
  ///
  /// // เก็บข้อมูลสินค้าทั้งหมด
  /// await cacheManager.putForHours(
  ///   key: 'products_category_$categoryId',
  ///   value: productsData,
  ///   hours: 6,
  /// );
  ///
  /// // เก็บตะกร้าสินค้าพร้อมเข้ารหัส
  /// await cacheManager.putForMinutes(
  ///   key: 'cart_$userId',
  ///   value: cartData,
  ///   minutes: 30,
  ///   encryptionKey: 'cart-secure-key',
  /// );
  /// ```
  factory CacheManagerLite.large({
    AppType appType = AppType.ecommerce,
    bool enableEncryption = true,
  }) {
    return CacheManagerLite(
      scalableConfig: ScalableCacheConfig.large(
        appType: appType,
        enableEncryption: enableEncryption,
      ),
    );
  }

  /// **Factory Constructor สำหรับแอปพลิเคชันองค์กร (Enterprise)**
  ///
  /// เหมาะสำหรับ: Banking App, Medical App, Government App, High-Security Apps
  ///
  /// ## คุณสมบัติ:
  /// - ขนาดแคช: 200MB+
  /// - ประสิทธิภาพ: Maximum
  /// - การเข้ารหัส: บังคับใช้ด้วย Custom Key
  /// - Security: ระดับสูงสุด
  /// - Background cleanup: อัตโนมัติขั้นสูง
  /// - Memory management: เต็มรูปแบบ
  ///
  /// ## พารามิเตอร์ที่ custom ได้:
  ///
  /// - **[appType]**: ประเภทแอปพลิเคชัน (default: AppType.ecommerce)
  /// - **[encryptionKey]**: คีย์เข้ารหัสแบบกำหนดเอง (highly recommended)
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // สำหรับแอป Banking
  /// final cacheManager = CacheManagerLite.enterprise(
  ///   appType: AppType.ecommerce,
  ///   encryptionKey: 'ultra-secure-banking-key-2024',
  /// );
  ///
  /// // เก็บข้อมูลบัญชีผู้ใช้แบบเข้ารหัส
  /// await cacheManager.putForMinutes(
  ///   key: 'account_$accountId',
  ///   value: accountData,
  ///   minutes: 15, // หมดอายุเร็วเพื่อความปลอดภัย
  /// );
  ///
  /// // เก็บ Session token แบบปลอดภัย
  /// await cacheManager.putForHours(
  ///   key: 'auth_token_$userId',
  ///   value: tokenData,
  ///   hours: 1,
  ///   encryptionKey: 'session-ultra-secure-key',
  /// );
  /// ```
  factory CacheManagerLite.enterprise({
    AppType appType = AppType.ecommerce,
    String? encryptionKey,
  }) {
    return CacheManagerLite(
      scalableConfig: ScalableCacheConfig.enterprise(
        appType: appType,
        encryptionKey: encryptionKey,
      ),
    );
  }

  // ===============================
  // User Level Factory Constructors (ตัวสร้างตามระดับผู้ใช้)
  // ===============================

  /// **🟢 Factory Constructor สำหรับผู้ใช้ระดับเริ่มต้น (Beginner)**
  ///
  /// เหมาะสำหรับ: นักพัฒนาที่เริ่มต้นใช้ระบบแคช, ต้องการความง่ายในการใช้งาน
  ///
  /// ## 🎯 คุณสมบัติสำหรับ Beginner:
  /// - ✅ API ง่ายและเข้าใจง่าย
  /// - ✅ ค่าเริ่มต้นที่ปลอดภัยและเหมาะสม
  /// - ✅ การตั้งค่าอัตโนมัติ
  /// - ✅ ไม่ต้องกังวลเรื่องการเข้ารหัส
  /// - ✅ การทำความสะอาดอัตโนมัติ
  ///
  /// ## พารามิเตอร์ที่ custom ได้:
  ///
  /// - **[appType]**: ประเภทแอป (default: AppType.utility)
  ///   - `AppType.utility` - แอป utility ง่ายๆ
  ///   - `AppType.social` - แอป social พื้นฐาน
  ///
  /// - **[cacheSize]**: ขนาดแคช (default: CacheSize.small)
  ///   - `CacheSize.small` - 10-25MB
  ///   - `CacheSize.medium` - 25-50MB
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // สำหรับแอป Todo ง่ายๆ
  /// final cacheManager = CacheManagerLite.forBeginner();
  ///
  /// // เก็บข้อมูลง่ายๆ
  /// await cacheManager.putForHours(
  ///   key: 'todo_list',
  ///   value: todoItems,
  ///   hours: 24,
  /// );
  ///
  /// // ดึงข้อมูลกลับมา
  /// final todos = await cacheManager.get('todo_list');
  ///
  /// // สำหรับแอป Social พื้นฐาน
  /// final socialCache = CacheManagerLite.forBeginner(
  ///   appType: AppType.social,
  ///   cacheSize: CacheSize.medium,
  /// );
  ///
  /// // เก็บโพสต์วันนี้
  /// await socialCache.putUntilEndOfDay(
  ///   key: 'today_posts',
  ///   value: posts,
  /// );
  /// ```
  factory CacheManagerLite.forBeginner({
    AppType appType = AppType.utility,
    CacheSize cacheSize = CacheSize.small,
  }) {
    return CacheManagerLite(
      scalableConfig: ScalableCacheConfig.forBeginner(
        appType: appType,
        cacheSize: cacheSize,
      ),
    );
  }

  /// **🔵 Factory Constructor สำหรับผู้ใช้ระดับกลาง (Intermediate)**
  ///
  /// เหมาะสำหรับ: นักพัฒนาที่มีประสบการณ์บ้าง ต้องการคุณสมบัติเพิ่มเติม
  ///
  /// ## 🎯 คุณสมบัติสำหรับ Intermediate:
  /// - ✅ ทุกคุณสมบัติของ Beginner
  /// - ✅ การเข้ารหัสแบบเลือกได้
  /// - ✅ การตั้งค่าประสิทธิภาพ
  /// - ✅ Batch operations
  /// - ✅ การจัดการหน่วยความจำขั้นสูง
  /// - ✅ การตรวจสอบสถานะแคช
  ///
  /// ## พารามิเตอร์ที่ custom ได้:
  ///
  /// - **[appType]**: ประเภทแอป (default: AppType.social)
  /// - **[cacheSize]**: ขนาดแคช (default: CacheSize.medium)
  /// - **[performanceLevel]**: ระดับประสิทธิภาพ (default: PerformanceLevel.balanced)
  ///   - `PerformanceLevel.low` - ประหยัดพลังงาน
  ///   - `PerformanceLevel.balanced` - สมดุล
  ///   - `PerformanceLevel.high` - ประสิทธิภาพสูง
  /// - **[enableEncryption]**: เปิดใช้การเข้ารหัส (default: false)
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // สำหรับแอป Social Media ระดับกลาง
  /// final cacheManager = CacheManagerLite.forIntermediate(
  ///   appType: AppType.social,
  ///   cacheSize: CacheSize.medium,
  ///   performanceLevel: PerformanceLevel.high,
  ///   enableEncryption: true,
  /// );
  ///
  /// // เก็บข้อมูลโปรไฟล์พร้อมเข้ารหัส
  /// await cacheManager.putForDays(
  ///   key: 'user_profile_$userId',
  ///   value: profileData,
  ///   days: 7,
  ///   encryptionKey: 'profile-key-2024',
  /// );
  ///
  /// // ตรวจสอบสถานะแคช
  /// final info = await cacheManager.getEntryInfo('user_profile_$userId');
  /// print('เหลือเวลา: ${info?.remainingTime}');
  ///
  /// // การใช้งานแบบ batch
  /// await cacheManager.putBatch({
  ///   'recent_posts': recentPosts,
  ///   'user_friends': friendsList,
  ///   'notifications': notifications,
  /// });
  /// ```
  factory CacheManagerLite.forIntermediate({
    AppType appType = AppType.social,
    CacheSize cacheSize = CacheSize.medium,
    PerformanceLevel performanceLevel = PerformanceLevel.balanced,
    bool enableEncryption = false,
  }) {
    return CacheManagerLite(
      scalableConfig: ScalableCacheConfig.forIntermediate(
        appType: appType,
        cacheSize: cacheSize,
        performanceLevel: performanceLevel,
        enableEncryption: enableEncryption,
      ),
    );
  }

  /// **🟠 Factory Constructor สำหรับผู้ใช้ระดับสูง (Advanced)**
  ///
  /// เหมาะสำหรับ: นักพัฒนาที่ต้องการควบคุมและปรับแต่งขั้นสูง
  ///
  /// ## 🎯 คุณสมบัติสำหรับ Advanced:
  /// - ✅ ทุกคุณสมบัติของ Intermediate
  /// - ✅ Custom CachePolicy แบบเต็มรูปแบบ
  /// - ✅ การจัดการ Memory Cache Ratio
  /// - ✅ Custom Encryption Key
  /// - ✅ การตรวจสอบประสิทธิภาพ
  /// - ✅ การขยายเวลาหมดอายุ
  /// - ✅ Real-time monitoring
  ///
  /// ## พารามิเตอร์ที่ custom ได้:
  ///
  /// - **[appType]**: ประเภทแอป (default: AppType.ecommerce)
  /// - **[cacheSize]**: ขนาดแคช (default: CacheSize.large)
  /// - **[performanceLevel]**: ระดับประสิทธิภาพ (default: PerformanceLevel.high)
  /// - **[enableEncryption]**: เปิดใช้การเข้ารหัส (default: true)
  /// - **[encryptionKey]**: คีย์เข้ารหัสแบบกำหนดเอง (customizable)
  /// - **[memoryCacheRatio]**: อัตราส่วน RAM ที่ใช้ (default: 0.15 = 15%)
  /// - **[customPolicy]**: นโยบายแคชแบบกำหนดเอง (fully customizable)
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // สร้าง Custom Policy
  /// final customPolicy = CachePolicy.expiresAt(
  ///   expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
  ///   encryptionKey: 'advanced-key-2024',
  /// );
  ///
  /// // สำหรับแอป E-commerce ขั้นสูง
  /// final cacheManager = CacheManagerLite.forAdvanced(
  ///   appType: AppType.ecommerce,
  ///   cacheSize: CacheSize.large,
  ///   performanceLevel: PerformanceLevel.high,
  ///   enableEncryption: true,
  ///   encryptionKey: 'ecommerce-master-key-2024',
  ///   memoryCacheRatio: 0.2, // ใช้ RAM 20%
  ///   customPolicy: customPolicy,
  /// );
  ///
  /// // เก็บข้อมูลสินค้าพร้อม custom expiration
  /// await cacheManager.put(
  ///   key: 'product_$productId',
  ///   value: productData,
  ///   policy: CachePolicy.endOfMonth(
  ///     encryptionKey: 'product-specific-key',
  ///   ),
  /// );
  ///
  /// // ตรวจสอบและขยายเวลา
  /// final remaining = await cacheManager.getRemainingTime('product_$productId');
  /// if (remaining != null && remaining.inHours < 2) {
  ///   await cacheManager.extendExpiration(
  ///     key: 'product_$productId',
  ///     additionalTime: Duration(days: 7),
  ///   );
  /// }
  /// ```
  factory CacheManagerLite.forAdvanced({
    AppType appType = AppType.ecommerce,
    CacheSize cacheSize = CacheSize.large,
    PerformanceLevel performanceLevel = PerformanceLevel.high,
    bool enableEncryption = true,
    String? encryptionKey,
    double memoryCacheRatio = 0.15,
    CachePolicy? customPolicy,
  }) {
    return CacheManagerLite(
      scalableConfig: ScalableCacheConfig.forAdvanced(
        appType: appType,
        cacheSize: cacheSize,
        performanceLevel: performanceLevel,
        enableEncryption: enableEncryption,
        encryptionKey: encryptionKey,
        memoryCacheRatio: memoryCacheRatio,
        customPolicy: customPolicy,
      ),
    );
  }

  /// **🔴 Factory Constructor สำหรับผู้ใช้ระดับผู้เชี่ยวชาญ (Expert)**
  ///
  /// เหมาะสำหรับ: นักพัฒนาผู้เชี่ยวชาญที่ต้องการการควบคุมเต็มรูปแบบ
  ///
  /// ## 🎯 คุณสมบัติสำหรับ Expert:
  /// - ✅ ทุกคุณสมบัติของ Advanced
  /// - ✅ การตั้งค่า Custom Size ด้วย Bytes
  /// - ✅ การควบคุม Background Cleanup แบบเต็มรูปแบบ
  /// - ✅ การจูนประสิทธิภาพระดับ Ultra
  /// - ✅ Advanced Debugging Tools
  /// - ✅ Real-time Cache Statistics
  /// - ✅ Manual Memory Management
  /// - ✅ Enterprise-level Security
  ///
  /// ## พารามิเตอร์ที่ custom ได้ทั้งหมด:
  ///
  /// - **[cacheSize]**: ขนาดแคชตามมาตรฐาน (required)
  /// - **[performanceLevel]**: ระดับประสิทธิภาพ (required)
  ///   - `PerformanceLevel.ultra` - ประสิทธิภาพสูงสุด
  /// - **[appType]**: ประเภทแอป (required)
  /// - **[customSizeBytes]**: ขนาดแคชแบบกำหนดเอง (highly customizable)
  ///   ```dart
  ///   customSizeBytes: 500 * 1024 * 1024, // 500MB custom
  ///   ```
  /// - **[enableEncryption]**: เปิดใช้การเข้ารหัส (default: true)
  /// - **[encryptionKey]**: คีย์เข้ารหัสแบบกำหนดเอง (fully customizable)
  /// - **[enableBackgroundCleanup]**: การทำความสะอาดอัตโนมัติ (customizable)
  /// - **[memoryCacheRatio]**: อัตราส่วน RAM (default: 0.1 = 10%)
  /// - **[customPolicy]**: นโยบายแคชแบบกำหนดเอง (fully customizable)
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // สำหรับแอป Enterprise Banking
  /// final expertCache = CacheManagerLite.forExpert(
  ///   cacheSize: CacheSize.enterprise,
  ///   performanceLevel: PerformanceLevel.ultra,
  ///   appType: AppType.ecommerce,
  ///   customSizeBytes: 1024 * 1024 * 1024, // 1GB custom
  ///   enableEncryption: true,
  ///   encryptionKey: 'ultra-secure-banking-key-2024',
  ///   enableBackgroundCleanup: true,
  ///   memoryCacheRatio: 0.05, // ใช้ RAM เพียง 5% เพื่อความปลอดภัย
  ///   customPolicy: CachePolicy.inMinutes(
  ///     15, // หมดอายุเร็วเพื่อความปลอดภัย
  ///     encryptionKey: 'session-ultra-key',
  ///   ),
  /// );
  ///
  /// // เก็บข้อมูลบัญชีแบบปลอดภัยสูงสุด
  /// await expertCache.put(
  ///   key: 'account_$accountId',
  ///   value: sensitiveAccountData,
  ///   policy: CachePolicy.inMinutes(
  ///     10,
  ///     encryptionKey: 'account-ultra-secure-key',
  ///   ),
  /// );
  ///
  /// // Real-time monitoring
  /// Timer.periodic(Duration(seconds: 30), (timer) async {
  ///   final stats = await expertCache.getCacheStats();
  ///   print('Cache Usage: ${stats.usedPercentage}%');
  ///   print('Total Entries: ${stats.entryCount}');
  ///
  ///   // Auto cleanup if needed
  ///   if (stats.usedPercentage > 90) {
  ///     await expertCache.performMaintenance();
  ///   }
  /// });
  /// ```
  factory CacheManagerLite.forExpert({
    required CacheSize cacheSize,
    required PerformanceLevel performanceLevel,
    required AppType appType,
    int? customSizeBytes,
    bool enableEncryption = true,
    String? encryptionKey,
    bool enableBackgroundCleanup = true,
    double memoryCacheRatio = 0.1,
    CachePolicy? customPolicy,
  }) {
    return CacheManagerLite(
      scalableConfig: ScalableCacheConfig.forExpert(
        cacheSize: cacheSize,
        performanceLevel: performanceLevel,
        appType: appType,
        customSizeBytes: customSizeBytes,
        enableEncryption: enableEncryption,
        encryptionKey: encryptionKey,
        enableBackgroundCleanup: enableBackgroundCleanup,
        memoryCacheRatio: memoryCacheRatio,
        customPolicy: customPolicy,
      ),
    );
  }

  /// **⚙️ Factory Constructor สำหรับการกำหนดค่าแบบกำหนดเองสมบูรณ์ (Custom)**
  ///
  /// เหมาะสำหรับ: นักพัฒนาที่ต้องการสร้างการตั้งค่าแบบเฉพาะเจาะจงตามความต้องการ
  ///
  /// ## 🎯 คุณสมบัติสำหรับ Custom:
  /// - ✅ การควบคุมขนาดแคชแบบ Byte-level
  /// - ✅ การสร้าง CachePolicy แบบเฉพาะเจาะจง
  /// - ✅ การปรับแต่งทุกพารามิเตอร์
  /// - ✅ ความยืดหยุ่นสูงสุด
  /// - ✅ เหมาะสำหรับ Research & Development
  /// - ✅ Perfect สำหรับ Prototype และ Testing
  ///
  /// ## พารามิเตอร์ที่ต้อง custom (required):
  ///
  /// - **[customSizeBytes]**: ขนาดแคชแบบไบต์ (จำเป็นต้องระบุ)
  ///   ```dart
  ///   customSizeBytes: 150 * 1024 * 1024, // 150MB exactly
  ///   customSizeBytes: 512 * 1024 * 1024, // 512MB exactly
  ///   customSizeBytes: 2 * 1024 * 1024 * 1024, // 2GB exactly
  ///   ```
  ///
  /// - **[customPolicy]**: นโยบายแคชแบบกำหนดเอง (จำเป็นต้องระบุ)
  ///   ```dart
  ///   // Policy แบบซับซ้อน
  ///   customPolicy: CachePolicy(
  ///     maxAge: Duration(minutes: 45),
  ///     expiresAt: DateTime(2024, 12, 25, 12, 0, 0),
  ///     encryptionKey: 'complex-key-with-rotation',
  ///   ),
  ///   ```
  ///
  /// ## พารามิเตอร์เสริมที่ custom ได้:
  ///
  /// - **[appType]**: ประเภทแอป (default: AppType.utility)
  /// - **[enableEncryption]**: เปิดใช้การเข้ารหัส (default: true)
  /// - **[encryptionKey]**: คีย์เข้ารหัสหลัก (fully customizable)
  /// - **[enableBackgroundCleanup]**: การทำความสะอาดอัตโนมัติ (default: true)
  /// - **[memoryCacheRatio]**: อัตราส่วน RAM (default: 0.2 = 20%)
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // ===============================
  /// // สำหรับ Research Application
  /// // ===============================
  ///
  /// final researchPolicy = CachePolicy.expiresAt(
  ///   expirationTime: DateTime.now().add(Duration(days: 30)),
  ///   encryptionKey: 'research-data-encryption-2024',
  /// );
  ///
  /// final researchCache = CacheManagerLite.custom(
  ///   customSizeBytes: 5 * 1024 * 1024 * 1024, // 5GB for large datasets
  ///   customPolicy: researchPolicy,
  ///   appType: AppType.utility,
  ///   enableEncryption: true,
  ///   encryptionKey: 'research-master-key',
  ///   memoryCacheRatio: 0.4, // ใช้ RAM 40% เพื่อความเร็ว
  /// );
  ///
  /// // เก็บ dataset ขนาดใหญ่
  /// await researchCache.put(
  ///   key: 'ml_dataset_v1',
  ///   value: massiveDataset,
  ///   policy: CachePolicy.never(), // ไม่หมดอายุ
  /// );
  ///
  /// // ===============================
  /// // สำหรับ IoT Application
  /// // ===============================
  ///
  /// final iotPolicy = CachePolicy.inMinutes(
  ///   5, // ข้อมูล sensor หมดอายุเร็ว
  ///   encryptionKey: 'iot-sensor-key',
  /// );
  ///
  /// final iotCache = CacheManagerLite.custom(
  ///   customSizeBytes: 10 * 1024 * 1024, // 10MB เท่านั้น สำหรับ IoT
  ///   customPolicy: iotPolicy,
  ///   appType: AppType.utility,
  ///   enableEncryption: true,
  ///   memoryCacheRatio: 0.05, // ใช้ RAM เพียง 5%
  ///   enableBackgroundCleanup: false, // ควบคุมการ cleanup เอง
  /// );
  ///
  /// // เก็บข้อมูล sensor
  /// await iotCache.putForMinutes(
  ///   key: 'sensor_${sensorId}_${timestamp}',
  ///   value: sensorData,
  ///   minutes: 3,
  /// );
  ///
  /// // ===============================
  /// // สำหรับ Gaming Tournament
  /// // ===============================
  ///
  /// final tournamentPolicy = CachePolicy.expiresAt(
  ///   expirationTime: DateTime(2024, 6, 15, 20, 0, 0), // สิ้นสุดเทิร์นเมนต์
  ///   encryptionKey: 'tournament-security-key',
  /// );
  ///
  /// final tournamentCache = CacheManagerLite.custom(
  ///   customSizeBytes: 300 * 1024 * 1024, // 300MB สำหรับเทิร์นเมนต์
  ///   customPolicy: tournamentPolicy,
  ///   appType: AppType.gaming,
  ///   enableEncryption: true,
  ///   encryptionKey: 'tournament-master-key-2024',
  ///   memoryCacheRatio: 0.3, // ใช้ RAM 30% เพื่อความเร็วสูง
  /// );
  ///
  /// // เก็บข้อมูลผู้เล่นในเทิร์นเมนต์
  /// await tournamentCache.put(
  ///   key: 'tournament_player_$playerId',
  ///   value: playerTournamentData,
  ///   policy: tournamentPolicy,
  /// );
  /// ```
  factory CacheManagerLite.custom({
    required int customSizeBytes,
    required CachePolicy customPolicy,
    AppType appType = AppType.utility,
    bool enableEncryption = true,
    String? encryptionKey,
    bool enableBackgroundCleanup = true,
    double memoryCacheRatio = 0.2,
  }) {
    return CacheManagerLite(
      scalableConfig: ScalableCacheConfig.custom(
        customSizeBytes: customSizeBytes,
        customPolicy: customPolicy,
        appType: appType,
        enableEncryption: enableEncryption,
        encryptionKey: encryptionKey,
        enableBackgroundCleanup: enableBackgroundCleanup,
        memoryCacheRatio: memoryCacheRatio,
      ),
    );
  }

  /// Gets the effective cache configuration.
  /// รับการกำหนดค่าแคชที่มีผล
  CacheConfig get effectiveConfig {
    if (scalableConfig != null) {
      return scalableConfig!.toCacheConfig();
    }
    return config ??
        CacheConfig(
          maxCacheSize: 50 * 1024 * 1024, // 50MB default
          defaultPolicy: CachePolicy(maxAge: Duration(hours: 6)),
        );
  }

  /// Initializes the cache manager.
  /// เริ่มต้นตัวจัดการแคช
  Future<void> _initialize() async {
    _hiveDataSource = HiveDataSource();
    await _hiveDataSource.init();
    _repository = HiveCacheRepository(_hiveDataSource);
    _getCacheUseCase = GetCacheUseCase(_repository);
    _putCacheUseCase = PutCacheUseCase(_repository);
    _clearCacheUseCase = ClearCacheUseCase(_repository);

    // Create Dio with cache interceptor
    // สร้าง Dio พร้อม interceptor แคช
    final dio = Dio();
    dio.interceptors.add(
      DioCacheInterceptor(
        _getCacheUseCase,
        _putCacheUseCase,
        defaultPolicy: effectiveConfig.defaultPolicy,
      ),
    );
    _dioDataSource = DioDataSource(dio);
  }

  /// Retrieves JSON data from cache or API.
  ///
  /// If the data is found in cache and not expired, returns cached data.
  /// Otherwise, fetches from the API, caches it, and returns the result.
  ///
  /// Example:
  /// ```dart
  /// final posts = await cacheManager.getJson(
  ///   'https://jsonplaceholder.typicode.com/posts',
  ///   policy: CachePolicy.inHours(1),
  /// );
  /// ```
  Future<dynamic> getJson(String url, {CachePolicy? policy}) async {
    final key = 'json_$url';
    final cached = await _getCacheUseCase(key);
    if (cached != null && !cached.isExpired) {
      return _decryptIfNeeded(cached.value, policy);
    }
    final data = await _dioDataSource.getJson(url);
    final entry = CacheEntry(
      key: key,
      value: _encryptIfNeeded(data, policy),
      createdAt: DateTime.now(),
      expiresAt: policy?.expiresAt ?? effectiveConfig.defaultPolicy.expiresAt,
      isEncrypted: policy?.encryptionKey != null,
    );
    await _putCacheUseCase(entry);
    return data;
  }

  /// Retrieves bytes from cache or API.
  ///
  /// If the data is found in cache and not expired, returns cached data.
  /// Otherwise, fetches from the API, caches it, and returns the result.
  ///
  /// Useful for caching images, files, or other binary content.
  ///
  /// Example:
  /// ```dart
  /// final imageBytes = await cacheManager.getBytes(
  ///   'https://example.com/image.jpg',
  ///   policy: CachePolicy.inDays(1),
  /// );
  /// ```
  Future<List<int>> getBytes(String url, {CachePolicy? policy}) async {
    final key = 'bytes_$url';
    final cached = await _getCacheUseCase(key);
    if (cached != null && !cached.isExpired) {
      return _decryptIfNeeded(cached.value, policy);
    }
    final data = await _dioDataSource.getBytes(url);
    final entry = CacheEntry(
      key: key,
      value: _encryptIfNeeded(data, policy),
      createdAt: DateTime.now(),
      expiresAt: policy?.expiresAt ?? effectiveConfig.defaultPolicy.expiresAt,
      isEncrypted: policy?.encryptionKey != null,
    );
    await _putCacheUseCase(entry);
    return data;
  }

  /// Stores data in cache with flexible expiration options.
  ///
  /// This is the main method for storing data in the cache with full customization
  /// of expiration time and encryption settings.
  ///
  /// Parameters:
  /// - [key]: Unique identifier for the cached data
  /// - [value]: The data to cache (can be any type)
  /// - [policy]: Complete cache policy with expiration and encryption
  /// - [maxAge]: Duration until expiration (alternative to policy)
  /// - [expiresAt]: Specific expiration time (alternative to policy)
  /// - [encryptionKey]: Optional encryption key for secure storage
  ///
  /// Example:
  /// ```dart
  /// // Basic storage with duration
  /// await cacheManager.put(
  ///   key: 'user_session',
  ///   value: sessionData,
  ///   maxAge: Duration(hours: 2),
  /// );
  ///
  /// // Storage with specific expiration time
  /// await cacheManager.put(
  ///   key: 'daily_report',
  ///   value: reportData,
  ///   expiresAt: DateTime(2024, 12, 31, 23, 59, 59),
  /// );
  ///
  /// // Encrypted storage
  /// await cacheManager.put(
  ///   key: 'sensitive_data',
  ///   value: userData,
  ///   maxAge: Duration(minutes: 30),
  ///   encryptionKey: 'my-secret-key',
  /// );
  /// ```
  Future<void> put({
    required String key,
    required dynamic value,
    CachePolicy? policy,
    Duration? maxAge,
    DateTime? expiresAt,
    String? encryptionKey,
  }) async {
    // Create effective cache policy
    CachePolicy? effectivePolicy = policy;

    if (effectivePolicy == null &&
        (maxAge != null || expiresAt != null || encryptionKey != null)) {
      if (expiresAt != null) {
        effectivePolicy = CachePolicy.expiresAt(
          expirationTime: expiresAt,
          encryptionKey: encryptionKey,
        );
      } else if (maxAge != null) {
        effectivePolicy = CachePolicy.duration(
          duration: maxAge,
          encryptionKey: encryptionKey,
        );
      } else if (encryptionKey != null) {
        effectivePolicy = CachePolicy(
          maxAge: effectiveConfig.defaultPolicy.maxAge,
          encryptionKey: encryptionKey,
        );
      }
    }

    final entry = CacheEntry(
      key: key,
      value: _encryptIfNeeded(value, effectivePolicy),
      createdAt: DateTime.now(),
      expiresAt: effectivePolicy?.getExpirationTime() ??
          effectiveConfig.defaultPolicy.getExpirationTime(),
      isEncrypted: effectivePolicy?.encryptionKey != null,
    );
    await _putCacheUseCase(entry);
  }

  /// Stores data in cache with duration from now.
  /// จัดเก็บข้อมูลในแคชด้วยระยะเวลาจากเวลาปัจจุบัน
  Future<void> putWithDuration({
    required String key,
    required dynamic value,
    required Duration duration,
    String? encryptionKey,
  }) async {
    await put(
      key: key,
      value: value,
      policy: CachePolicy.duration(
        duration: duration,
        encryptionKey: encryptionKey,
      ),
    );
  }

  /// Stores data in cache with specific expiration time.
  /// จัดเก็บข้อมูลในแคชด้วยเวลาหมดอายุเฉพาะ
  Future<void> putWithExpirationTime({
    required String key,
    required dynamic value,
    required DateTime expirationTime,
    String? encryptionKey,
  }) async {
    await put(
      key: key,
      value: value,
      policy: CachePolicy.expiresAt(
        expirationTime: expirationTime,
        encryptionKey: encryptionKey,
      ),
    );
  }

  /// Stores data in cache that expires in X minutes.
  /// จัดเก็บข้อมูลในแคชที่หมดอายุใน X นาที
  Future<void> putForMinutes({
    required String key,
    required dynamic value,
    required int minutes,
    String? encryptionKey,
  }) async {
    await put(
      key: key,
      value: value,
      policy: CachePolicy.inMinutes(minutes, encryptionKey: encryptionKey),
    );
  }

  /// Stores data in cache that expires in X hours.
  ///
  /// A convenience method for storing data with hour-based expiration.
  ///
  /// Parameters:
  /// - [key]: Unique identifier for the cached data
  /// - [value]: The data to cache
  /// - [hours]: Number of hours until expiration
  /// - [encryptionKey]: Optional encryption key for secure storage
  ///
  /// Example:
  /// ```dart
  /// // Store user session for 2 hours
  /// await cacheManager.putForHours(
  ///   key: 'user_session_${userId}',
  ///   value: sessionData,
  ///   hours: 2,
  /// );
  ///
  /// // Store encrypted data for 6 hours
  /// await cacheManager.putForHours(
  ///   key: 'secure_token',
  ///   value: tokenData,
  ///   hours: 6,
  ///   encryptionKey: 'token-encryption-key',
  /// );
  /// ```
  Future<void> putForHours({
    required String key,
    required dynamic value,
    required int hours,
    String? encryptionKey,
  }) async {
    await put(
      key: key,
      value: value,
      policy: CachePolicy.inHours(hours, encryptionKey: encryptionKey),
    );
  }

  /// Stores data in cache that expires in X days.
  /// จัดเก็บข้อมูลในแคชที่หมดอายุใน X วัน
  Future<void> putForDays({
    required String key,
    required dynamic value,
    required int days,
    String? encryptionKey,
  }) async {
    await put(
      key: key,
      value: value,
      policy: CachePolicy.inDays(days, encryptionKey: encryptionKey),
    );
  }

  /// Stores data in cache that expires at end of day.
  /// จัดเก็บข้อมูลในแคชที่หมดอายุเมื่อสิ้นวัน
  Future<void> putUntilEndOfDay({
    required String key,
    required dynamic value,
    String? encryptionKey,
  }) async {
    await put(
      key: key,
      value: value,
      policy: CachePolicy.endOfDay(encryptionKey: encryptionKey),
    );
  }

  /// Stores data in cache that expires at end of week.
  /// จัดเก็บข้อมูลในแคชที่หมดอายุเมื่อสิ้นสุปดาห์
  Future<void> putUntilEndOfWeek({
    required String key,
    required dynamic value,
    String? encryptionKey,
  }) async {
    await put(
      key: key,
      value: value,
      policy: CachePolicy.endOfWeek(encryptionKey: encryptionKey),
    );
  }

  /// Stores data in cache that expires at end of month.
  /// จัดเก็บข้อมูลในแคชที่หมดอายุเมื่อสิ้นเดือน
  Future<void> putUntilEndOfMonth({
    required String key,
    required dynamic value,
    String? encryptionKey,
  }) async {
    await put(
      key: key,
      value: value,
      policy: CachePolicy.endOfMonth(encryptionKey: encryptionKey),
    );
  }

  /// Stores data in cache that never expires (practically).
  /// จัดเก็บข้อมูลในแคชที่ไม่หมดอายุ (จริงๆ แล้ว)
  Future<void> putPermanent({
    required String key,
    required dynamic value,
    String? encryptionKey,
  }) async {
    await put(
      key: key,
      value: value,
      policy: CachePolicy.never(encryptionKey: encryptionKey),
    );
  }

  /// Retrieves data from cache by key.
  ///
  /// Returns the cached data if it exists and hasn't expired, otherwise returns null.
  ///
  /// Type parameter [T] can be used to specify the expected return type.
  ///
  /// Parameters:
  /// - [key]: The key of the cached data to retrieve
  ///
  /// Returns the cached value of type [T] or null if not found or expired.
  ///
  /// Example:
  /// ```dart
  /// // Get data with automatic type inference
  /// final userData = await cacheManager.get('user_profile');
  ///
  /// // Get data with explicit type
  /// final userProfile = await cacheManager.get<Map<String, dynamic>>('user_profile');
  ///
  /// // Check if data exists before using
  /// final cachedPosts = await cacheManager.get('recent_posts');
  /// if (cachedPosts != null) {
  ///   // Use cached data
  ///   displayPosts(cachedPosts);
  /// } else {
  ///   // Fetch fresh data
  ///   final freshPosts = await api.getPosts();
  ///   await cacheManager.putForHours(key: 'recent_posts', value: freshPosts, hours: 1);
  /// }
  /// ```
  Future<T?> get<T>(String key) async {
    final cached = await _getCacheUseCase(key);
    if (cached != null && !cached.isExpired) {
      return cached.value;
    }
    return null;
  }

  /// Gets cache entry info including expiration details.
  /// ดึงข้อมูลรายการแคชรวมถึงรายละเอียดการหมดอายุ
  Future<CacheEntryInfo?> getEntryInfo(String key) async {
    final cached = await _getCacheUseCase(key);
    if (cached == null) return null;

    return CacheEntryInfo(
      key: cached.key,
      hasValue: true,
      isExpired: cached.isExpired,
      createdAt: cached.createdAt,
      expiresAt: cached.expiresAt,
      isEncrypted: cached.isEncrypted,
      remainingTime: cached.expiresAt?.difference(DateTime.now()),
    );
  }

  /// Gets data from cache even if expired (for debugging/recovery).
  /// ดึงข้อมูลจากแคชแม้ว่าจะหมดอายุแล้ว (สำหรับการ debug/กู้คืน)
  Future<dynamic> getExpired(String key) async {
    final cached = await _getCacheUseCase(key);
    return cached?.value;
  }

  /// Checks if a key exists in cache and is not expired.
  /// ตรวจสอบว่า key มีอยู่ในแคชและยังไม่หมดอายุ
  Future<bool> exists(String key) async {
    final cached = await _getCacheUseCase(key);
    return cached != null && !cached.isExpired;
  }

  /// Checks if a key exists in cache (regardless of expiration).
  /// ตรวจสอบว่า key มีอยู่ในแคช (ไม่สนใจการหมดอายุ)
  Future<bool> existsAny(String key) async {
    final cached = await _getCacheUseCase(key);
    return cached != null;
  }

  /// Gets remaining time until expiration for a cache key.
  /// รับเวลาที่เหลือจนกว่าจะหมดอายุสำหรับ key ของแคช
  Future<Duration?> getRemainingTime(String key) async {
    final cached = await _getCacheUseCase(key);
    if (cached?.expiresAt == null) return null;

    final remaining = cached!.expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Extends the expiration time of a cache entry.
  /// ขยายเวลาหมดอายุของรายการแคช
  Future<bool> extendExpiration({
    required String key,
    Duration? additionalTime,
    DateTime? newExpirationTime,
  }) async {
    final cached = await _getCacheUseCase(key);
    if (cached == null) return false;

    DateTime? newExpiry;
    if (newExpirationTime != null) {
      newExpiry = newExpirationTime;
    } else if (additionalTime != null) {
      newExpiry = (cached.expiresAt ?? DateTime.now()).add(additionalTime);
    } else {
      return false;
    }

    final updatedEntry = CacheEntry(
      key: cached.key,
      value: cached.value,
      createdAt: cached.createdAt,
      expiresAt: newExpiry,
      isEncrypted: cached.isEncrypted,
    );

    await _putCacheUseCase(updatedEntry);
    return true;
  }

  /// Clears all cache.
  /// ล้างแคชทั้งหมด
  Future<void> clear() async {
    await _clearCacheUseCase();
  }

  /// Encrypts data if encryption key is provided.
  /// เข้ารหัสข้อมูลหากมีการให้คีย์การเข้ารหัส
  dynamic _encryptIfNeeded(dynamic data, CachePolicy? policy) {
    if (policy?.encryptionKey != null) {
      final jsonString = data is String ? data : data.toString();
      return utils.EncryptionUtils.encryptData(
        jsonString,
        policy!.encryptionKey!,
      );
    }
    return data;
  }

  /// Decrypts data if it was encrypted.
  /// ถอดรหัสข้อมูลหากถูกเข้ารหัส
  dynamic _decryptIfNeeded(dynamic data, CachePolicy? policy) {
    if (policy?.encryptionKey != null && data is String) {
      return utils.EncryptionUtils.decryptData(data, policy!.encryptionKey!);
    }
    return data;
  }
}
