import 'package:encrypt/encrypt.dart' as encrypt;

/// Utility class for encryption and decryption.
/// คลาสยูทิลิตี้สำหรับการเข้ารหัสและถอดรหัส
class EncryptionUtils {
  /// Encrypts the given data using AES.
  /// เข้ารหัสข้อมูลที่กำหนดโดยใช้ AES
  static String encryptData(String data, String key) {
    final keyBytes = encrypt.Key.fromUtf8(
      key.padRight(32, ' ').substring(0, 32),
    );
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  /// Decrypts the given encrypted data using AES.
  /// ถอดรหัสข้อมูลที่เข้ารหัสโดยใช้ AES
  static String decryptData(String encryptedData, String key) {
    final keyBytes = encrypt.Key.fromUtf8(
      key.padRight(32, ' ').substring(0, 32),
    );
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return decrypted;
  }
}
