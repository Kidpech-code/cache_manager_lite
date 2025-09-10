/// **CachePolicy - นโยบายการจัดการแคชที่ยืดหยุ่นและทรงพลัง**
///
/// คลาสสำหรับกำหนดกฎเกณฑ์การจัดเก็บและหมดอายุของข้อมูลแคช
/// รองรับการตั้งเวลาหมดอายุแบบต่างๆ และการเข้ารหัสข้อมูล
///
/// ## 🎯 การใช้งาน
///
/// CachePolicy ควบคุมพฤติกรรมของแคชในด้านต่างๆ:
/// - เวลาหมดอายุ (Duration หรือ DateTime)
/// - การเข้ารหัสข้อมุล (AES Encryption)
/// - ขนาดสูงสุดของ entry
/// - การตรวจสอบความถูกต้อง
///
/// ## ⚡ ตัวอย่างการใช้งานพื้นฐาน
///
/// ```dart
/// // Policy แบบ Duration (2 ชั่วโมงจากเวลาปัจจุบัน)
/// final policy = CachePolicy.duration(
///   duration: Duration(hours: 2),
///   encryptionKey: 'secure-key-2024',
/// );
///
/// // Policy แบบ DateTime (หมดอายุเวลาเฉพาะ)
/// final policy = CachePolicy.expiresAt(
///   expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
///   encryptionKey: 'new-year-key',
/// );
/// ```
///
/// ## 🕒 Factory Methods สำหรับความสะดวก
///
/// ```dart
/// // ตามหน่วยเวลา
/// final policy1 = CachePolicy.inMinutes(30);
/// final policy2 = CachePolicy.inHours(6);
/// final policy3 = CachePolicy.inDays(7);
///
/// // ตามช่วงเวลาธรรมชาติ
/// final policy4 = CachePolicy.endOfDay();      // 23:59:59 วันนี้
/// final policy5 = CachePolicy.endOfWeek();     // วันอาทิตย์
/// final policy6 = CachePolicy.endOfMonth();    // วันสุดท้ายของเดือน
/// final policy7 = CachePolicy.never();         // ไม่หมดอายุ
/// ```
class CachePolicy {
  /// **ระยะเวลาสูงสุดของแคช (customizable)**
  ///
  /// กำหนดว่าข้อมูลแคชจะคงอยู่เป็นระยะเวลาเท่าไหร่นับจากเวลาที่สร้าง
  ///
  /// **ตัวอย่างการ custom:**
  /// ```dart
  /// maxAge: Duration(minutes: 15),     // 15 นาที
  /// maxAge: Duration(hours: 2),        // 2 ชั่วโมง
  /// maxAge: Duration(days: 30),        // 30 วัน
  /// maxAge: Duration(seconds: 30),     // 30 วินาที
  /// ```
  ///
  /// **หมายเหตุ:** หากระบุทั้ง maxAge และ expiresAt, ระบบจะใช้ expiresAt เป็นหลัก
  final Duration? maxAge;

  /// **วันเวลาหมดอายุที่แน่นอน (highly customizable)**
  ///
  /// กำหนดเวลาที่แน่นอนว่าข้อมูลแคชจะหมดอายุเมื่อไหร่
  /// มีความยืดหยุ่นสูงและสามารถกำหนดได้ละเอียด
  ///
  /// **ตัวอย่างการ custom:**
  /// ```dart
  /// // หมดอายุเมื่อสิ้นปี
  /// expiresAt: DateTime(2024, 12, 31, 23, 59, 59),
  ///
  /// // หมดอายุเวลา 18:00 วันนี้
  /// expiresAt: DateTime.now().copyWith(hour: 18, minute: 0, second: 0),
  ///
  /// // หมดอายุใน 3 วันข้างหน้า เวลา 9:00
  /// expiresAt: DateTime.now().add(Duration(days: 3)).copyWith(hour: 9),
  ///
  /// // หมดอายุวันจันทร์หน้า
  /// expiresAt: DateTime.now().add(Duration(days: 7 - DateTime.now().weekday + 1)),
  /// ```
  final DateTime? expiresAt;

  /// **คีย์การเข้ารหัสข้อมูล (fully customizable)**
  ///
  /// ใช้สำหรับเข้ารหัสข้อมูลแคชด้วย AES encryption เพื่อความปลอดภัย
  /// สามารถกำหนดคีย์ได้อย่างอิสระตามความต้องการด้านความปลอดภัย
  ///
  /// **ตัวอย่างการ custom:**
  /// ```dart
  /// // คีย์พื้นฐาน
  /// encryptionKey: 'my-secret-key-2024',
  ///
  /// // คีย์สำหรับ production
  /// encryptionKey: 'prod-ultra-secure-key-v2-2024',
  ///
  /// // คีย์สำหรับ user-specific data
  /// encryptionKey: 'user-${userId}-private-key',
  ///
  /// // คีย์แบบ timestamp rotation
  /// encryptionKey: 'key-${DateTime.now().millisecondsSinceEpoch}',
  ///
  /// // คีย์สำหรับข้อมูลสำคัญ
  /// encryptionKey: 'banking-grade-security-key-2024',
  /// ```
  ///
  /// **หมายเหตุ:** หากไม่ระบุ encryptionKey ข้อมูลจะไม่ถูกเข้ารหัส
  final String? encryptionKey;

  /// **ขนาดสูงสุดของข้อมูลแคช (customizable)**
  ///
  /// กำหนดขนาดสูงสุดในหน่วยไบต์ที่ entry นี้สามารถมีได้
  /// ช่วยในการควบคุมการใช้หน่วยความจำ
  ///
  /// **ตัวอย่างการ custom:**
  /// ```dart
  /// maxSize: 1024,                    // 1KB
  /// maxSize: 1024 * 1024,             // 1MB
  /// maxSize: 10 * 1024 * 1024,        // 10MB
  /// maxSize: 100 * 1024 * 1024,       // 100MB
  /// maxSize: null,                    // ไม่จำกัดขนาด
  /// ```
  final int? maxSize;

  /// **Constructor หลักของ CachePolicy**
  ///
  /// สร้าง CachePolicy ด้วยพารามิเตอร์ที่ยืดหยุ่น รองรับทั้งการตั้งเวลาแบบ Duration และ DateTime
  ///
  /// ## พารามิเตอร์ที่สามารถ custom ได้:
  ///
  /// - **[maxAge]**: ระยะเวลาหมดอายุจากเวลาสร้าง (optional)
  ///   ```dart
  ///   maxAge: Duration(hours: 6),        // หมดอายุใน 6 ชั่วโมง
  ///   maxAge: Duration(minutes: 30),     // หมดอายุใน 30 นาที
  ///   maxAge: Duration(days: 7),         // หมดอายุใน 7 วัน
  ///   ```
  ///
  /// - **[expiresAt]**: เวลาหมดอายุที่แน่นอน (optional, จะ override maxAge)
  ///   ```dart
  ///   expiresAt: DateTime(2024, 12, 25, 12, 0, 0),  // คริสต์มาส เที่ยง
  ///   expiresAt: DateTime.now().add(Duration(days: 1)), // พรุ่งนี้ เวลาเดียวกัน
  ///   ```
  ///
  /// - **[encryptionKey]**: คีย์เข้ารหัส (optional)
  ///   ```dart
  ///   encryptionKey: 'my-secret-key-2024',
  ///   encryptionKey: 'user-${userId}-key',
  ///   ```
  ///
  /// - **[maxSize]**: ขนาดสูงสุดในไบต์ (optional)
  ///   ```dart
  ///   maxSize: 1024 * 1024,  // 1MB
  ///   maxSize: null,         // ไม่จำกัด
  ///   ```
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // แบบ Duration only
  /// final policy1 = CachePolicy(
  ///   maxAge: Duration(hours: 2),
  ///   encryptionKey: 'session-key',
  /// );
  ///
  /// // แบบ DateTime only
  /// final policy2 = CachePolicy(
  ///   expiresAt: DateTime(2024, 6, 15, 18, 0, 0),
  ///   encryptionKey: 'event-key',
  ///   maxSize: 5 * 1024 * 1024, // 5MB
  /// );
  ///
  /// // แบบมีทั้งคู่ (expiresAt จะเป็นหลัก)
  /// final policy3 = CachePolicy(
  ///   maxAge: Duration(days: 7),      // backup
  ///   expiresAt: DateTime.now().add(Duration(hours: 6)), // หลัก
  ///   encryptionKey: 'hybrid-key',
  /// );
  /// ```
  ///
  /// **หมายเหตุ:** ต้องระบุอย่างน้อย maxAge หรือ expiresAt อย่างใดอย่างหนึ่ง
  CachePolicy({this.maxAge, this.expiresAt, this.encryptionKey, this.maxSize})
    : assert(
        maxAge != null || expiresAt != null,
        'Either maxAge or expiresAt must be provided',
      );

  /// Factory constructor for creating a policy with duration from now.
  /// ตัวสร้างแฟกทอรีสำหรับสร้างนโยบายด้วยระยะเวลาจากเวลาปัจจุบัน
  factory CachePolicy.duration({
    required Duration duration,
    String? encryptionKey,
    int? maxSize,
  }) {
    return CachePolicy(
      maxAge: duration,
      encryptionKey: encryptionKey,
      maxSize: maxSize,
    );
  }

  /// Factory constructor for creating a policy with specific expiration time.
  /// ตัวสร้างแฟกทอรีสำหรับสร้างนโยบายด้วยเวลาหมดอายุเฉพาะ
  factory CachePolicy.expiresAt({
    required DateTime expirationTime,
    String? encryptionKey,
    int? maxSize,
  }) {
    return CachePolicy(
      expiresAt: expirationTime,
      encryptionKey: encryptionKey,
      maxSize: maxSize,
    );
  }

  /// Factory constructor for creating a policy that expires in X minutes.
  /// ตัวสร้างแฟกทอรีสำหรับสร้างนโยบายที่หมดอายุใน X นาที
  factory CachePolicy.inMinutes(
    int minutes, {
    String? encryptionKey,
    int? maxSize,
  }) {
    return CachePolicy(
      maxAge: Duration(minutes: minutes),
      encryptionKey: encryptionKey,
      maxSize: maxSize,
    );
  }

  /// Factory constructor for creating a policy that expires in X hours.
  /// ตัวสร้างแฟกทอรีสำหรับสร้างนโยบายที่หมดอายุใน X ชั่วโมง
  factory CachePolicy.inHours(
    int hours, {
    String? encryptionKey,
    int? maxSize,
  }) {
    return CachePolicy(
      maxAge: Duration(hours: hours),
      encryptionKey: encryptionKey,
      maxSize: maxSize,
    );
  }

  /// Factory constructor for creating a policy that expires in X days.
  /// ตัวสร้างแฟกทอรีสำหรับสร้างนโยบายที่หมดอายุใน X วัน
  factory CachePolicy.inDays(int days, {String? encryptionKey, int? maxSize}) {
    return CachePolicy(
      maxAge: Duration(days: days),
      encryptionKey: encryptionKey,
      maxSize: maxSize,
    );
  }

  /// Factory constructor for creating a policy that expires at end of day.
  /// ตัวสร้างแฟกทอรีสำหรับสร้างนโยบายที่หมดอายุเมื่อสิ้นวัน
  factory CachePolicy.endOfDay({String? encryptionKey, int? maxSize}) {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return CachePolicy(
      expiresAt: endOfDay,
      encryptionKey: encryptionKey,
      maxSize: maxSize,
    );
  }

  /// Factory constructor for creating a policy that expires at end of week.
  /// ตัวสร้างแฟกทอรีสำหรับสร้างนโยบายที่หมดอายุเมื่อสิ้นสุปดาห์
  factory CachePolicy.endOfWeek({String? encryptionKey, int? maxSize}) {
    final now = DateTime.now();
    final daysUntilSunday = 7 - now.weekday;
    final endOfWeek = DateTime(
      now.year,
      now.month,
      now.day + daysUntilSunday,
      23,
      59,
      59,
    );
    return CachePolicy(
      expiresAt: endOfWeek,
      encryptionKey: encryptionKey,
      maxSize: maxSize,
    );
  }

  /// Factory constructor for creating a policy that expires at end of month.
  /// ตัวสร้างแฟกทอรีสำหรับสร้างนโยบายที่หมดอายุเมื่อสิ้นเดือน
  factory CachePolicy.endOfMonth({String? encryptionKey, int? maxSize}) {
    final now = DateTime.now();
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return CachePolicy(
      expiresAt: endOfMonth,
      encryptionKey: encryptionKey,
      maxSize: maxSize,
    );
  }

  /// Factory constructor for creating a never-expiring policy.
  /// ตัวสร้างแฟกทอรีสำหรับสร้างนโยบายที่ไม่หมดอายุ
  factory CachePolicy.never({String? encryptionKey, int? maxSize}) {
    return CachePolicy(
      maxAge: Duration(days: 365 * 100), // 100 years - practically never
      encryptionKey: encryptionKey,
      maxSize: maxSize,
    );
  }

  /// Gets the effective expiration date/time.
  /// รับวันเวลาหมดอายุที่มีผล
  ///
  /// Priority: expiresAt > maxAge calculation
  /// ลำดับความสำคัญ: expiresAt > การคำนวณจาก maxAge
  DateTime? getExpirationTime([DateTime? baseTime]) {
    // If specific expiration time is set, use it
    if (expiresAt != null) {
      return expiresAt;
    }

    // Otherwise, calculate from maxAge
    if (maxAge != null) {
      final base = baseTime ?? DateTime.now();
      return base.add(maxAge!);
    }

    return null;
  }

  /// Gets the remaining time until expiration.
  /// รับเวลาที่เหลือจนกว่าจะหมดอายุ
  Duration? getRemainingTime([DateTime? baseTime]) {
    final expiration = getExpirationTime(baseTime);
    if (expiration == null) return null;

    final now = baseTime ?? DateTime.now();
    final remaining = expiration.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Checks if this policy would be expired at the given time.
  /// ตรวจสอบว่านโยบายนี้จะหมดอายุหรือไม่ ณ เวลาที่กำหนด
  bool isExpiredAt(DateTime checkTime, [DateTime? creationTime]) {
    final expiration = getExpirationTime(creationTime);
    if (expiration == null) return false;
    return checkTime.isAfter(expiration);
  }

  /// Creates a copy of this policy with modified parameters.
  /// สร้างสำเนาของนโยบายนี้โดยปรับเปลี่ยนพารามิเตอร์
  CachePolicy copyWith({
    Duration? maxAge,
    DateTime? expiresAt,
    String? encryptionKey,
    int? maxSize,
  }) {
    return CachePolicy(
      maxAge: maxAge ?? this.maxAge,
      expiresAt: expiresAt ?? this.expiresAt,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      maxSize: maxSize ?? this.maxSize,
    );
  }
}
