import 'cache_config.dart';
import 'cache_policy.dart';

/// Cache size presets for different application scales.
/// ชุดการกำหนดขนาดแคชสำหรับแอปพลิเคชันขนาดต่างๆ
enum CacheSize {
  /// For small apps with minimal caching needs (5MB)
  /// สำหรับแอปเล็กที่ต้องการแคชน้อย (5MB)
  small,

  /// For medium apps with moderate caching (50MB)
  /// สำหรับแอปขนาดกลางที่ต้องการแคชปานกลาง (50MB)
  medium,

  /// For large apps with extensive caching (200MB)
  /// สำหรับแอปขนาดใหญ่ที่ต้องการแคชมาก (200MB)
  large,

  /// For enterprise apps with heavy caching (1GB)
  /// สำหรับแอปองค์กรที่ต้องการแคชหนัก (1GB)
  enterprise,

  /// Custom size - user defined
  /// ขนาดกำหนดเอง - ผู้ใช้กำหนดเอง
  custom,
}

/// Performance level presets for different performance requirements.
/// ระดับประสิทธิภาพสำหรับความต้องการด้านประสิทธิภาพที่แตกต่างกัน
enum PerformanceLevel {
  /// Basic performance with longer cache duration (24 hours)
  /// ประสิทธิภาพพื้นฐานกับระยะเวลาแคชยาวนาน (24 ชั่วโมง)
  basic,

  /// Balanced performance (6 hours)
  /// ประสิทธิภาพสมดุล (6 ชั่วโมง)
  balanced,

  /// High performance with shorter cache duration (1 hour)
  /// ประสิทธิภาพสูงกับระยะเวลาแคชสั้น (1 ชั่วโมง)
  high,

  /// Real-time performance with very short cache (5 minutes)
  /// ประสิทธิภาพเรียลไทม์กับแคชระยะสั้นมาก (5 นาที)
  realtime,
}

/// Application type presets for common app categories.
/// ประเภทแอปพลิเคชันสำหรับหมวดหมู่แอปทั่วไป
enum AppType {
  /// Social media apps with image and content caching
  /// แอปโซเชียลมีเดียที่มีการแคชรูปภาพและเนื้อหา
  social,

  /// E-commerce apps with product data caching
  /// แอปอีคอมเมิร์ซที่มีการแคชข้อมูลสินค้า
  ecommerce,

  /// News apps with article caching
  /// แอปข่าวที่มีการแคชบทความ
  news,

  /// Gaming apps with asset caching
  /// แอปเกมที่มีการแคชทรัพยากร
  gaming,

  /// Educational apps with content caching
  /// แอปการศึกษาที่มีการแคชเนื้อหา
  education,

  /// Utility apps with minimal caching
  /// แอปยูทิลิตี้ที่มีการแคชน้อย
  utility,
}

/// User skill level for appropriate cache configuration complexity.
/// ระดับทักษะผู้ใช้สำหรับความซับซ้อนการกำหนดค่าแคชที่เหมาะสม
enum UserLevel {
  /// Beginner/Novice level - Simple configurations with sensible defaults
  /// ระดับเริ่มต้น/ผู้เริ่มต้น - การกำหนดค่าง่ายๆ พร้อมค่าเริ่มต้นที่สมเหตุสมผล
  beginner,

  /// Intermediate/Competent level - Moderate customization options
  /// ระดับกลาง/มีความสามารถ - ตัวเลือกการปรับแต่งปานกลาง
  intermediate,

  /// Advanced/Proficient level - Full control with advanced options
  /// ระดับสูง/มีความชำนาญ - การควบคุมเต็มรูปแบบพร้อมตัวเลือกขั้นสูง
  advanced,

  /// Expert level - Complete customization and fine-tuning capabilities
  /// ระดับผู้เชี่ยวชาญ - ความสามารถในการปรับแต่งและปรับจูนอย่างสมบูรณ์
  expert,
}

/// Extended cache configuration with app-scale support.
/// การกำหนดค่าแคชขยายพร้อมการรองรับขนาดแอป
class ScalableCacheConfig {
  /// Cache size configuration
  /// การกำหนดค่าขนาดแคช
  final CacheSize cacheSize;

  /// Performance level configuration
  /// การกำหนดค่าระดับประสิทธิภาพ
  final PerformanceLevel performanceLevel;

  /// Application type for optimized settings
  /// ประเภทแอปพลิเคชันสำหรับการตั้งค่าที่เหมาะสม
  final AppType appType;

  /// User skill level for configuration complexity
  /// ระดับทักษะผู้ใช้สำหรับความซับซ้อนของการกำหนดค่า
  final UserLevel userLevel;

  /// Custom cache size in bytes (only used when cacheSize is custom)
  /// ขนาดแคชกำหนดเองในไบต์ (ใช้เฉพาะเมื่อ cacheSize เป็น custom)
  final int? customSizeBytes;

  /// Whether to enable encryption by default
  /// เปิดใช้งานการเข้ารหัสตามค่าเริ่มต้นหรือไม่
  final bool enableEncryption;

  /// Default encryption key
  /// คีย์การเข้ารหัสเริ่มต้น
  final String? defaultEncryptionKey;

  /// Whether to enable background cleanup
  /// เปิดใช้งานการล้างข้อมูลในพื้นหลังหรือไม่
  final bool enableBackgroundCleanup;

  /// Memory cache ratio (0.0 to 1.0) - what percentage to keep in memory
  /// อัตราส่วนแคชในหน่วยความจำ (0.0 ถึง 1.0) - เปอร์เซ็นต์ที่จะเก็บในหน่วยความจำ
  final double memoryCacheRatio;

  /// Custom cache policy for advanced users
  /// นโยบายแคชกำหนดเองสำหรับผู้ใช้ขั้นสูง
  final CachePolicy? customCachePolicy;

  ScalableCacheConfig({
    this.cacheSize = CacheSize.medium,
    this.performanceLevel = PerformanceLevel.balanced,
    this.appType = AppType.utility,
    this.userLevel = UserLevel.intermediate,
    this.customSizeBytes,
    this.enableEncryption = false,
    this.defaultEncryptionKey,
    this.enableBackgroundCleanup = true,
    this.memoryCacheRatio = 0.2, // 20% in memory by default
    this.customCachePolicy,
  });

  /// Gets the cache size in bytes based on the selected preset.
  /// รับขนาดแคชในไบต์ตามการตั้งค่าที่เลือก
  int get cacheSizeBytes {
    switch (cacheSize) {
      case CacheSize.small:
        return 5 * 1024 * 1024; // 5MB
      case CacheSize.medium:
        return 50 * 1024 * 1024; // 50MB
      case CacheSize.large:
        return 200 * 1024 * 1024; // 200MB
      case CacheSize.enterprise:
        return 1024 * 1024 * 1024; // 1GB
      case CacheSize.custom:
        return customSizeBytes ??
            50 * 1024 * 1024; // Default to medium if custom not set
    }
  }

  /// Gets the default cache duration based on performance level.
  /// รับระยะเวลาแคชเริ่มต้นตามระดับประสิทธิภาพ
  Duration get defaultCacheDuration {
    switch (performanceLevel) {
      case PerformanceLevel.basic:
        return Duration(hours: 24);
      case PerformanceLevel.balanced:
        return Duration(hours: 6);
      case PerformanceLevel.high:
        return Duration(hours: 1);
      case PerformanceLevel.realtime:
        return Duration(minutes: 5);
    }
  }

  /// Gets optimized settings based on app type.
  /// รับการตั้งค่าที่เหมาะสมตามประเภทแอป
  Map<String, dynamic> get appTypeOptimizations {
    switch (appType) {
      case AppType.social:
        return {
          'imageCompressionEnabled': true,
          'prefetchEnabled': true,
          'maxConcurrentRequests': 6,
          'imageCacheDuration': Duration(days: 7),
        };
      case AppType.ecommerce:
        return {
          'productCacheDuration': Duration(hours: 12),
          'priceCacheDuration': Duration(minutes: 30),
          'inventoryCacheDuration': Duration(minutes: 5),
          'compressionEnabled': true,
        };
      case AppType.news:
        return {
          'articleCacheDuration': Duration(hours: 8),
          'headlineCacheDuration': Duration(minutes: 15),
          'imageCacheDuration': Duration(days: 3),
          'offlineReadingEnabled': true,
        };
      case AppType.gaming:
        return {
          'assetCacheDuration': Duration(days: 30),
          'userDataCacheDuration': Duration(minutes: 1),
          'leaderboardCacheDuration': Duration(minutes: 5),
          'preloadingEnabled': true,
        };
      case AppType.education:
        return {
          'contentCacheDuration': Duration(days: 15),
          'progressCacheDuration': Duration(minutes: 30),
          'mediaCacheDuration': Duration(days: 7),
          'offlineModeEnabled': true,
        };
      case AppType.utility:
        return {
          'dataCacheDuration': Duration(hours: 3),
          'configCacheDuration': Duration(hours: 12),
          'minimalFootprint': true,
        };
    }
  }

  /// Creates a preset configuration for small apps.
  /// สร้างการกำหนดค่าสำเร็จรูปสำหรับแอปขนาดเล็ก
  factory ScalableCacheConfig.small({
    AppType appType = AppType.utility,
    bool enableEncryption = false,
  }) {
    return ScalableCacheConfig(
      cacheSize: CacheSize.small,
      performanceLevel: PerformanceLevel.basic,
      appType: appType,
      enableEncryption: enableEncryption,
      memoryCacheRatio: 0.3, // Higher memory ratio for small apps
    );
  }

  /// Creates a preset configuration for medium apps.
  /// สร้างการกำหนดค่าสำเร็จรูปสำหรับแอปขนาดกลาง
  factory ScalableCacheConfig.medium({
    AppType appType = AppType.social,
    bool enableEncryption = false,
  }) {
    return ScalableCacheConfig(
      cacheSize: CacheSize.medium,
      performanceLevel: PerformanceLevel.balanced,
      appType: appType,
      enableEncryption: enableEncryption,
      memoryCacheRatio: 0.2,
    );
  }

  /// Creates a preset configuration for large apps.
  /// สร้างการกำหนดค่าสำเร็จรูปสำหรับแอปขนาดใหญ่
  factory ScalableCacheConfig.large({
    AppType appType = AppType.ecommerce,
    bool enableEncryption = true,
  }) {
    return ScalableCacheConfig(
      cacheSize: CacheSize.large,
      performanceLevel: PerformanceLevel.high,
      appType: appType,
      enableEncryption: enableEncryption,
      memoryCacheRatio: 0.15,
    );
  }

  /// Creates a preset configuration for enterprise apps.
  /// สร้างการกำหนดค่าสำเร็จรูปสำหรับแอปองค์กร
  factory ScalableCacheConfig.enterprise({
    AppType appType = AppType.ecommerce,
    String? encryptionKey,
  }) {
    return ScalableCacheConfig(
      cacheSize: CacheSize.enterprise,
      performanceLevel: PerformanceLevel.high,
      appType: appType,
      enableEncryption: true,
      defaultEncryptionKey: encryptionKey,
      memoryCacheRatio: 0.1,
    );
  }

  // ===============================
  // User Level Factory Constructors
  // ===============================

  /// Creates a configuration optimized for beginner users.
  /// สร้างการกำหนดค่าที่เหมาะสำหรับผู้ใช้ระดับเริ่มต้น
  ///
  /// Features:
  /// - Simple, sensible defaults
  /// - Automatic configuration
  /// - Minimal customization required
  factory ScalableCacheConfig.forBeginner({
    AppType appType = AppType.utility,
    CacheSize cacheSize = CacheSize.small,
  }) {
    return ScalableCacheConfig(
      cacheSize: cacheSize,
      performanceLevel: PerformanceLevel.basic,
      appType: appType,
      userLevel: UserLevel.beginner,
      enableEncryption: false, // Keep it simple
      enableBackgroundCleanup: true, // Automatic cleanup
      memoryCacheRatio: 0.3, // Higher memory ratio for simplicity
    );
  }

  /// Creates a configuration optimized for intermediate users.
  /// สร้างการกำหนดค่าที่เหมาะสำหรับผู้ใช้ระดับกลาง
  ///
  /// Features:
  /// - Balanced performance and simplicity
  /// - Some customization options
  /// - Good defaults with room for adjustment
  factory ScalableCacheConfig.forIntermediate({
    AppType appType = AppType.social,
    CacheSize cacheSize = CacheSize.medium,
    PerformanceLevel performanceLevel = PerformanceLevel.balanced,
    bool enableEncryption = false,
  }) {
    return ScalableCacheConfig(
      cacheSize: cacheSize,
      performanceLevel: performanceLevel,
      appType: appType,
      userLevel: UserLevel.intermediate,
      enableEncryption: enableEncryption,
      enableBackgroundCleanup: true,
      memoryCacheRatio: 0.2,
    );
  }

  /// Creates a configuration optimized for advanced users.
  /// สร้างการกำหนดค่าที่เหมาะสำหรับผู้ใช้ระดับสูง
  ///
  /// Features:
  /// - Full control over most settings
  /// - Advanced performance options
  /// - Custom policies supported
  factory ScalableCacheConfig.forAdvanced({
    AppType appType = AppType.ecommerce,
    CacheSize cacheSize = CacheSize.large,
    PerformanceLevel performanceLevel = PerformanceLevel.high,
    bool enableEncryption = true,
    String? encryptionKey,
    double memoryCacheRatio = 0.15,
    CachePolicy? customPolicy,
  }) {
    return ScalableCacheConfig(
      cacheSize: cacheSize,
      performanceLevel: performanceLevel,
      appType: appType,
      userLevel: UserLevel.advanced,
      enableEncryption: enableEncryption,
      defaultEncryptionKey: encryptionKey,
      enableBackgroundCleanup: true,
      memoryCacheRatio: memoryCacheRatio,
      customCachePolicy: customPolicy,
    );
  }

  /// Creates a configuration optimized for expert users.
  /// สร้างการกำหนดค่าที่เหมาะสำหรับผู้ใช้ระดับผู้เชี่ยวชาญ
  ///
  /// Features:
  /// - Complete customization control
  /// - All advanced features available
  /// - Fine-tuning capabilities
  factory ScalableCacheConfig.forExpert({
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
    return ScalableCacheConfig(
      cacheSize: cacheSize,
      performanceLevel: performanceLevel,
      appType: appType,
      userLevel: UserLevel.expert,
      customSizeBytes: customSizeBytes,
      enableEncryption: enableEncryption,
      defaultEncryptionKey: encryptionKey,
      enableBackgroundCleanup: enableBackgroundCleanup,
      memoryCacheRatio: memoryCacheRatio,
      customCachePolicy: customPolicy,
    );
  }

  /// Creates a completely custom configuration for expert users.
  /// สร้างการกำหนดค่าแบบกำหนดเองสมบูรณ์สำหรับผู้ใช้ผู้เชี่ยวชาญ
  ///
  /// Features:
  /// - Custom cache size in bytes
  /// - Custom cache policies
  /// - All parameters customizable
  factory ScalableCacheConfig.custom({
    required int customSizeBytes,
    required CachePolicy customPolicy,
    AppType appType = AppType.utility,
    bool enableEncryption = true,
    String? encryptionKey,
    bool enableBackgroundCleanup = true,
    double memoryCacheRatio = 0.2,
  }) {
    return ScalableCacheConfig(
      cacheSize: CacheSize.custom,
      performanceLevel:
          PerformanceLevel.balanced, // Will be overridden by custom policy
      appType: appType,
      userLevel: UserLevel.expert,
      customSizeBytes: customSizeBytes,
      enableEncryption: enableEncryption,
      defaultEncryptionKey: encryptionKey,
      enableBackgroundCleanup: enableBackgroundCleanup,
      memoryCacheRatio: memoryCacheRatio,
      customCachePolicy: customPolicy,
    );
  }

  /// Converts to standard CacheConfig for compatibility.
  /// แปลงเป็น CacheConfig มาตรฐานเพื่อความเข้ากันได้
  CacheConfig toCacheConfig() {
    return CacheConfig(
      maxCacheSize: cacheSizeBytes,
      defaultPolicy:
          customCachePolicy ??
          CachePolicy(
            maxAge: defaultCacheDuration,
            encryptionKey: enableEncryption ? defaultEncryptionKey : null,
          ),
    );
  }
}
