/// **CacheEntry - รายการแคชหลักที่เก็บข้อมูลครบถ้วน**
///
/// เป็น Entity หลักที่เก็บข้อมูลแคชพร้อมข้อมูล metadata ครบถ้วน
/// รวมถึงการจัดการเวลาหมดอายุ, การเข้ารหัส, และการตรวจสอบสถานะ
///
/// ## 🎯 การใช้งาน
///
/// CacheEntry เป็นหน่วยพื้นฐานของการเก็บข้อมูลแคช ประกอบด้วย:
/// - Key สำหรับการอ้างอิง
/// - Value ที่เป็นข้อมูลจริง
/// - เวลาการสร้างและหมดอายุ
/// - สถานะการเข้ารหัส
///
/// ## ⚡ ตัวอย่างการสร้าง
///
/// ```dart
/// // รายการแคชพื้นฐาน
/// final entry = CacheEntry(
///   key: 'user_profile_123',
///   value: userProfileData,
///   createdAt: DateTime.now(),
///   expiresAt: DateTime.now().add(Duration(hours: 2)),
///   isEncrypted: false,
/// );
///
/// // รายการแคชที่เข้ารหัส
/// final secureEntry = CacheEntry(
///   key: 'sensitive_data',
///   value: encryptedData,
///   createdAt: DateTime.now(),
///   expiresAt: DateTime(2024, 12, 31),
///   isEncrypted: true,
/// );
/// ```
class CacheEntry {
  /// **คีย์ที่ไม่ซ้ำกันของรายการแคช (ไม่สามารถ custom หลังสร้าง)**
  ///
  /// ใช้เป็นตัวระบุเอกลักษณ์ของรายการแคชแต่ละตัว
  ///
  /// **แนวทางการตั้งชื่อ Key:**
  /// ```dart
  /// key: 'user_profile_${userId}',           // โปรไฟล์ผู้ใช้
  /// key: 'product_${productId}',             // ข้อมูลสินค้า
  /// key: 'api_response_${endpoint}_${hash}', // Response จาก API
  /// key: 'image_cache_${imageUrl.hashCode}', // รูปภาพ
  /// key: 'session_${sessionId}',             // Session data
  /// ```
  final String key;

  /// **ข้อมูลที่แคชไว้ (ไม่สามารถ custom หลังสร้าง)**
  ///
  /// สามารถเป็นข้อมูลประเภทใดก็ได้ (String, Map, List, Object, etc.)
  /// ข้อมูลจะถูกเข้ารหัสหากมีการระบุ encryption
  ///
  /// **ตัวอย่างประเภทข้อมูล:**
  /// ```dart
  /// value: 'Simple string data',                    // String
  /// value: {'name': 'John', 'age': 30},            // Map
  /// value: [1, 2, 3, 4, 5],                       // List
  /// value: userObject,                             // Custom Object
  /// value: base64ImageData,                        // Binary data
  /// value: jsonEncodedData,                        // JSON
  /// ```
  final dynamic value;

  /// **เวลาที่สร้างรายการแคช (ไม่สามารถ custom หลังสร้าง)**
  ///
  /// บันทึกเวลาที่รายการแคชถูกสร้างขึ้น ใช้สำหรับการคำนวณอายุและการหมดอายุ
  ///
  /// **การใช้งาน:**
  /// ```dart
  /// createdAt: DateTime.now(),                     // เวลาปัจจุบัน
  /// createdAt: DateTime.utc(2024, 6, 15, 10, 0),  // เวลา UTC เฉพาะ
  /// ```
  final DateTime createdAt;

  /// **เวลาหมดอายุของรายการแคช (customizable)**
  ///
  /// กำหนดเวลาที่รายการแคชจะหมดอายุ หากเป็น null แสดงว่าไม่หมดอายุ
  ///
  /// **ตัวอย่างการ custom:**
  /// ```dart
  /// expiresAt: null,                                    // ไม่หมดอายุ
  /// expiresAt: DateTime.now().add(Duration(hours: 1)), // หมดอายุใน 1 ชั่วโมง
  /// expiresAt: DateTime(2024, 12, 31, 23, 59, 59),    // หมดอายุเฉพาะวันที่
  /// expiresAt: DateTime.now().copyWith(               // หมดอายุเที่ยงวันนี้
  ///   hour: 12, minute: 0, second: 0, millisecond: 0),
  /// ```
  final DateTime? expiresAt;

  /// **สถานะการเข้ารหัสข้อมูล (ไม่สามารถ custom หลังสร้าง)**
  ///
  /// ระบุว่าข้อมูลใน value ถูกเข้ารหัสหรือไม่
  ///
  /// **ค่าที่เป็นไปได้:**
  /// ```dart
  /// isEncrypted: false,  // ข้อมูลไม่ได้เข้ารหัส (ปกติ)
  /// isEncrypted: true,   // ข้อมูลถูกเข้ารหัสด้วย AES
  /// ```
  final bool isEncrypted;

  /// **Constructor สำหรับสร้าง CacheEntry**
  ///
  /// สร้างรายการแคชใหม่ด้วยข้อมูลครบถ้วน
  ///
  /// ## พารามิเตอร์ที่ต้องระบุ (required):
  ///
  /// - **[key]**: คีย์เฉพาะของรายการแคช
  ///   ```dart
  ///   key: 'user_profile_${userId}',
  ///   key: 'api_cache_${endpoint.replaceAll('/', '_')}',
  ///   ```
  ///
  /// - **[value]**: ข้อมูลที่ต้องการแคช
  ///   ```dart
  ///   value: userProfileData,
  ///   value: {'status': 'success', 'data': responseData},
  ///   ```
  ///
  /// - **[createdAt]**: เวลาที่สร้าง
  ///   ```dart
  ///   createdAt: DateTime.now(),
  ///   ```
  ///
  /// ## พารามิเตอร์เสริม (optional):
  ///
  /// - **[expiresAt]**: เวลาหมดอายุ
  ///   ```dart
  ///   expiresAt: DateTime.now().add(Duration(hours: 6)),
  ///   expiresAt: null, // ไม่หมดอายุ
  ///   ```
  ///
  /// - **[isEncrypted]**: สถานะการเข้ารหัส (default: false)
  ///   ```dart
  ///   isEncrypted: true,  // ข้อมูลเข้ารหัสแล้ว
  ///   isEncrypted: false, // ข้อมูลปกติ
  ///   ```
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// // รายการแคชพื้นฐาน
  /// final basicEntry = CacheEntry(
  ///   key: 'todo_list',
  ///   value: todoItems,
  ///   createdAt: DateTime.now(),
  ///   expiresAt: DateTime.now().add(Duration(hours: 24)),
  /// );
  ///
  /// // รายการแคชที่เข้ารหัส
  /// final secureEntry = CacheEntry(
  ///   key: 'payment_info_${userId}',
  ///   value: encryptedPaymentData,
  ///   createdAt: DateTime.now(),
  ///   expiresAt: DateTime.now().add(Duration(minutes: 15)),
  ///   isEncrypted: true,
  /// );
  ///
  /// // รายการแคชไม่หมดอายุ
  /// final permanentEntry = CacheEntry(
  ///   key: 'app_config',
  ///   value: configurationData,
  ///   createdAt: DateTime.now(),
  ///   expiresAt: null, // ไม่หมดอายุ
  /// );
  /// ```
  CacheEntry({
    required this.key,
    required this.value,
    required this.createdAt,
    this.expiresAt,
    this.isEncrypted = false,
  });

  /// **ตรวจสอบว่ารายการแคชหมดอายุหรือไม่**
  ///
  /// ส่งคืน true หากรายการแคชหมดอายุแล้ว, false หากยังไม่หมดอายุหรือไม่มีการตั้งเวลาหมดอายุ
  ///
  /// ## การทำงาน:
  /// - หาก `expiresAt` เป็น null = ไม่หมดอายุ (คืนค่า false)
  /// - หาก `expiresAt` มีค่าและเวลาปัจจุบันเกินแล้ว = หมดอายุ (คืนค่า true)
  /// - หาก `expiresAt` มีค่าและเวลาปัจจุบันยังไม่เกิน = ยังไม่หมดอายุ (คืนค่า false)
  ///
  /// ## ตัวอย่างการใช้งาน:
  ///
  /// ```dart
  /// final entry = CacheEntry(
  ///   key: 'temp_data',
  ///   value: someData,
  ///   createdAt: DateTime.now(),
  ///   expiresAt: DateTime.now().add(Duration(minutes: 30)),
  /// );
  ///
  /// // ตรวจสอบการหมดอายุ
  /// if (entry.isExpired) {
  ///   print('ข้อมูลหมดอายุแล้ว ต้องโหลดใหม่');
  ///   // โหลดข้อมูลใหม่
  /// } else {
  ///   print('ข้อมูลยังใช้ได้');
  ///   // ใช้ข้อมูลจากแคช
  /// }
  ///
  /// // สำหรับรายการที่ไม่หมดอายุ
  /// final permanentEntry = CacheEntry(
  ///   key: 'permanent_data',
  ///   value: data,
  ///   createdAt: DateTime.now(),
  ///   expiresAt: null,
  /// );
  /// print(permanentEntry.isExpired); // จะเป็น false เสมอ
  /// ```
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  /// Converts the CacheEntry to a JSON map for storage.
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isEncrypted': isEncrypted,
    };
  }

  /// Creates a CacheEntry from a JSON map.
  factory CacheEntry.fromJson(Map<String, dynamic> json) {
    return CacheEntry(
      key: json['key'],
      value: json['value'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : null,
      isEncrypted: json['isEncrypted'] ?? false,
    );
  }
}

/// Information about a cache entry including expiration details.
/// ข้อมูลเกี่ยวกับรายการแคชรวมถึงรายละเอียดการหมดอายุ
class CacheEntryInfo {
  /// The cache key.
  /// คีย์ของแคช
  final String key;

  /// Whether the entry has a value.
  /// ว่ารายการมีค่าหรือไม่
  final bool hasValue;

  /// Whether the entry has expired.
  /// ว่ารายการหมดอายุหรือไม่
  final bool isExpired;

  /// When the entry was created.
  /// เมื่อรายการถูกสร้าง
  final DateTime createdAt;

  /// When the entry expires (if set).
  /// เมื่อรายการหมดอายุ (ถ้ามีการตั้งค่า)
  final DateTime? expiresAt;

  /// Whether the entry is encrypted.
  /// ว่ารายการถูกเข้ารหัสหรือไม่
  final bool isEncrypted;

  /// Remaining time until expiration.
  /// เวลาที่เหลือจนกว่าจะหมดอายุ
  final Duration? remainingTime;

  /// Constructor for CacheEntryInfo.
  CacheEntryInfo({
    required this.key,
    required this.hasValue,
    required this.isExpired,
    required this.createdAt,
    this.expiresAt,
    required this.isEncrypted,
    this.remainingTime,
  });

  /// Gets a human-readable status description.
  /// รับคำอธิบายสถานะที่อ่านง่าย
  String get statusDescription {
    if (!hasValue) return 'Not found';
    if (isExpired) return 'Expired';
    if (remainingTime != null) {
      final remaining = remainingTime!;
      if (remaining.inDays > 0) {
        return 'Expires in ${remaining.inDays} days';
      } else if (remaining.inHours > 0) {
        return 'Expires in ${remaining.inHours} hours';
      } else if (remaining.inMinutes > 0) {
        return 'Expires in ${remaining.inMinutes} minutes';
      } else {
        return 'Expires in ${remaining.inSeconds} seconds';
      }
    }
    return 'Active';
  }

  /// Gets the age of the cache entry.
  /// รับอายุของรายการแคช
  Duration get age => DateTime.now().difference(createdAt);

  /// Converts to a JSON map for debugging.
  /// แปลงเป็น JSON map สำหรับการ debug
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'hasValue': hasValue,
      'isExpired': isExpired,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isEncrypted': isEncrypted,
      'remainingTimeSeconds': remainingTime?.inSeconds,
      'statusDescription': statusDescription,
      'ageSeconds': age.inSeconds,
    };
  }
}
