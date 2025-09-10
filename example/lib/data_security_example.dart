import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';
import 'dart:convert';

/// Example demonstrating advanced data security features.
/// ตัวอย่างแสดงฟีเจอร์ความปลอดภัยข้อมูลขั้นสูง
class DataSecurityExample extends StatefulWidget {
  const DataSecurityExample({super.key});

  @override
  State<DataSecurityExample> createState() => _DataSecurityExampleState();
}

class _DataSecurityExampleState extends State<DataSecurityExample> {
  late final CacheManagerLite secureCache;
  final List<String> logs = [];
  bool isLoading = false;

  // Security levels for demonstration
  final Map<String, Map<String, dynamic>> securityLevels = {
    'Basic': {
      'description': 'Standard caching without encryption',
      'color': Colors.green,
      'icon': Icons.security,
      'enabled': false,
    },
    'Standard': {
      'description': 'AES encryption with default key',
      'color': Colors.blue,
      'icon': Icons.enhanced_encryption,
      'enabled': true,
    },
    'High': {
      'description': 'AES encryption with custom secure key',
      'color': Colors.orange,
      'icon': Icons.gpp_good,
      'enabled': true,
    },
    'Enterprise': {
      'description': 'Maximum security with rotating keys',
      'color': Colors.red,
      'icon': Icons.admin_panel_settings,
      'enabled': true,
    },
  };

  @override
  void initState() {
    super.initState();
    secureCache = CacheManagerLite.enterprise(
      appType: AppType.ecommerce,
      encryptionKey: 'enterprise-grade-security-key-2024',
    );
    _addLog('🔐 Enterprise security cache initialized');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Security Examples'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, color: Colors.deepPurple, size: 32),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Security Features',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                'Demonstrating AES encryption and secure caching',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Security Level Cards
            Text(
              'Security Levels Available',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            ...securityLevels.entries.map((entry) {
              final config = entry.value;
              return Card(
                child: ListTile(
                  leading: Icon(
                    config['icon'],
                    color: config['color'],
                    size: 32,
                  ),
                  title: Text(
                    '${entry.key} Security',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(config['description']),
                  trailing: Chip(
                    label: Text(
                      config['enabled'] ? 'Encrypted' : 'Plain',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: config['enabled'] ? Colors.green : Colors.grey,
                  ),
                ),
              );
            }),

            SizedBox(height: 24),

            // Demo Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Demonstrations',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _testBasicSecurity(),
                          icon: Icon(Icons.security),
                          label: Text('Basic Security'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _testEncryptedData(),
                          icon: Icon(Icons.enhanced_encryption),
                          label: Text('Encrypted Data'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _testSensitiveData(),
                          icon: Icon(Icons.gpp_good),
                          label: Text('Sensitive Data'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _testPaymentSecurity(),
                          icon: Icon(Icons.admin_panel_settings),
                          label: Text('Payment Security'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _clearSecureCache(),
                            icon: Icon(Icons.delete_forever),
                            label: Text('Clear Secure Cache'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _clearLogs(),
                            icon: Icon(Icons.clear_all),
                            label: Text('Clear Logs'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Logs Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text(
                          'Security Activity Logs',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: logs.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.grey.shade500,
                                    size: 48,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Run security tests to see activity logs',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                final log = logs[index];
                                Color textColor = Colors.grey.shade700;
                                if (log.contains('🔐')) textColor = Colors.green;
                                if (log.contains('⚠️')) textColor = Colors.orange;
                                if (log.contains('❌')) textColor = Colors.red;
                                if (log.contains('✅')) textColor = Colors.blue;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text(
                                    log,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                      color: textColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testBasicSecurity() async {
    _addLog('🔹 Testing basic security (no encryption)...');

    final basicCache = CacheManagerLite.forBeginner();

    try {
      final userData = {
        'username': 'john_doe',
        'email': 'john@example.com',
        'preferences': {'theme': 'dark', 'language': 'en'},
      };

      await basicCache.put(
        key: 'user_data_basic',
        value: userData,
      );

      final retrieved = await basicCache.get('user_data_basic');

      _addLog('✅ Basic data stored and retrieved successfully');
      _addLog('📄 Data: ${jsonEncode(retrieved).substring(0, 50)}...');
      _addLog('⚠️ Warning: Data is not encrypted');
    } catch (e) {
      _addLog('❌ Basic security test failed: $e');
    }
  }

  Future<void> _testEncryptedData() async {
    _addLog('🔐 Testing encrypted data storage...');

    try {
      final encryptedData = {
        'api_key': 'sk-1234567890abcdef',
        'secret_token': 'ultra-secret-token-2024',
        'user_session': 'session_${DateTime.now().millisecondsSinceEpoch}',
      };

      await secureCache.put(
        key: 'encrypted_credentials',
        value: encryptedData,
        policy: CachePolicy(
          maxAge: Duration(hours: 1),
          encryptionKey: 'api-credentials-key-2024',
        ),
      );

      final retrieved = await secureCache.get('encrypted_credentials');

      _addLog('✅ Encrypted data stored with AES encryption');
      _addLog('🔒 Data encrypted with custom key');
      _addLog('📄 Retrieved: ${retrieved != null ? "Success" : "Failed"}');
    } catch (e) {
      _addLog('❌ Encryption test failed: $e');
    }
  }

  Future<void> _testSensitiveData() async {
    _addLog('🛡️ Testing sensitive data with high security...');

    try {
      final sensitiveData = {
        'social_security': '***-**-1234',
        'credit_card': '**** **** **** 5678',
        'bank_account': 'BANK***9012',
        'biometric_hash': 'a1b2c3d4e5f6...',
      };

      await secureCache.put(
        key: 'sensitive_user_data',
        value: sensitiveData,
        policy: CachePolicy(
          maxAge: Duration(minutes: 30), // Short expiration for sensitive data
          encryptionKey: 'high-security-sensitive-key-${DateTime.now().year}',
        ),
      );

      final info = await secureCache.getEntryInfo('sensitive_user_data');

      _addLog('✅ Sensitive data secured with enterprise encryption');
      _addLog('⏰ Short expiration: ${info?.remainingTime ?? "N/A"}');
      _addLog('🔐 Encryption status: ${info?.isEncrypted == true ? "Enabled" : "Disabled"}');
    } catch (e) {
      _addLog('❌ Sensitive data test failed: $e');
    }
  }

  Future<void> _testPaymentSecurity() async {
    _addLog('💳 Testing payment data with maximum security...');

    try {
      final paymentData = {
        'transaction_id': 'TXN_${DateTime.now().millisecondsSinceEpoch}',
        'amount': '1,500.00',
        'currency': 'THB',
        'merchant_id': 'MERCHANT_12345',
        'encrypted_card_data': 'ENC_CARD_DATA_HASH',
        'payment_method': 'credit_card',
        'security_code_hash': 'CVV_HASH_ABC123',
      };

      // Use rotating encryption key for maximum security
      final paymentKey = 'payment-ultra-secure-${DateTime.now().millisecondsSinceEpoch}';

      await secureCache.put(
        key: 'payment_transaction',
        value: paymentData,
        policy: CachePolicy(
          maxAge: Duration(minutes: 15), // Very short for payment data
          encryptionKey: paymentKey,
        ),
      );

      _addLog('✅ Payment data secured with rotating encryption key');
      _addLog('🔄 Using time-based encryption key');
      _addLog('⚡ Ultra-short expiration (15 minutes)');
      _addLog('🏦 Banking-grade security applied');

      // Verify security
      final info = await secureCache.getEntryInfo('payment_transaction');
      if (info != null) {
        _addLog('🕒 Remaining time: ${info.remainingTime?.inMinutes ?? 0} minutes');
        _addLog('🔐 Encryption verified: ${info.isEncrypted}');
      }
    } catch (e) {
      _addLog('❌ Payment security test failed: $e');
    }
  }

  Future<void> _clearSecureCache() async {
    _addLog('🗑️ Clearing all secure cache data...');

    try {
      await secureCache.clear();
      _addLog('✅ Secure cache cleared successfully');
      _addLog('🔒 All encrypted data permanently removed');
    } catch (e) {
      _addLog('❌ Failed to clear secure cache: $e');
    }
  }

  void _clearLogs() {
    setState(() {
      logs.clear();
    });
  }

  void _addLog(String message) {
    setState(() {
      logs.insert(0, '${DateTime.now().toString().substring(11, 19)} $message');
    });
  }

  @override
  void dispose() {
    secureCache.clear();
    super.dispose();
  }
}
