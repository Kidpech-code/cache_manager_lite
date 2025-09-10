import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';
import 'dart:math';

void main() {
  runApp(AuthApp());
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: AuthenticationExample(),
    );
  }
}

class AuthenticationExample extends StatefulWidget {
  const AuthenticationExample({super.key});

  @override
  createState() => _AuthenticationExampleState();
}

class _AuthenticationExampleState extends State<AuthenticationExample> {
  // Cache Manager สำหรับ Authentication
  late final CacheManagerLite cacheManager;
  bool _isInitialized = false;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  // User Data
  Map<String, dynamic>? _userProfile;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  // Controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _initializeAuth() async {
    // สร้าง Cache Manager สำหรับ Auth
    cacheManager = CacheManagerLite.forBeginner(
      appType: AppType.ecommerce,
      cacheSize: CacheSize.medium,
    );

    setState(() {
      _isInitialized = true;
    });

    // ตรวจสอบ session ที่บันทึกไว้
    await _checkExistingSession();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'ออกจากระบบ',
            ),
        ],
      ),
      body: _isLoggedIn ? _buildDashboard() : _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.lock, size: 64, color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ระบบ Authentication ด้วย Cache',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 32),

          // Username field
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'ชื่อผู้ใช้',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
              hintText: 'ลอง: admin, user, demo',
            ),
          ),

          SizedBox(height: 16),

          // Password field
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'รหัสผ่าน',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              hintText: 'ลอง: password, 123456',
            ),
          ),

          SizedBox(height: 24),

          // Login button
          ElevatedButton(
            onPressed: _isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('กำลังเข้าสู่ระบบ...'),
                    ],
                  )
                : Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(fontSize: 16),
                  ),
          ),

          SizedBox(height: 16),

          // Demo accounts info
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🧪 บัญชีทดสอบ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                SizedBox(height: 8),
                Text('• admin / password (ผู้ดูแลระบบ)'),
                Text('• user / 123456 (ผู้ใช้ทั่วไป)'),
                Text('• demo / demo (บัญชีทดสอบ)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Card
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'ยินดีต้อนรับ, ${_userProfile?['name'] ?? 'ผู้ใช้'}!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'บทบาท: ${_userProfile?['role'] ?? 'ไม่ทราบ'}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Auth Info Section
          _buildSectionCard(
            title: '🔐 ข้อมูลการยืนยันตัวตน',
            children: [
              _buildInfoRow('Access Token', _maskedToken(_accessToken)),
              _buildInfoRow('Refresh Token', _maskedToken(_refreshToken)),
              _buildInfoRow('หมดอายุ', _formatExpiry()),
              _buildInfoRow('สถานะ', _getTokenStatus()),
            ],
          ),

          SizedBox(height: 16),

          // Cache Status Section
          _buildCacheStatusSection(),

          SizedBox(height: 16),

          // User Profile Section
          _buildSectionCard(
            title: '👤 ข้อมูลผู้ใช้',
            children: [
              _buildInfoRow('ID', _userProfile?['id']?.toString() ?? '-'),
              _buildInfoRow('ชื่อผู้ใช้', _userProfile?['username'] ?? '-'),
              _buildInfoRow('อีเมล', _userProfile?['email'] ?? '-'),
              _buildInfoRow('เข้าสู่ระบบล่าสุด', _userProfile?['lastLogin'] ?? '-'),
            ],
          ),

          SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _refreshToken != null ? _refreshAccessToken : null,
                  icon: Icon(Icons.refresh),
                  label: Text('ต่ออายุ Token'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _clearCache,
                  icon: Icon(Icons.clear_all),
                  label: Text('ล้าง Cache'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheStatusSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getCacheStatus(),
      builder: (context, snapshot) {
        return _buildSectionCard(
          title: '💾 สถานะ Cache',
          children: [
            if (snapshot.connectionState == ConnectionState.waiting)
              Center(child: CircularProgressIndicator())
            else if (snapshot.hasError)
              Text('Error: ${snapshot.error}')
            else if (snapshot.hasData) ...[
              for (var item in snapshot.data!) _buildInfoRow(item['key'], item['status']),
            ] else
              Text('ไม่มีข้อมูล Cache'),
          ],
        );
      },
    );
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage('กรุณากรอกชื่อผู้ใช้และรหัสผ่าน', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // จำลองการเรียก API
      await Future.delayed(Duration(seconds: 2));

      // ตรวจสอบ credentials
      final authResult = _validateCredentials(username, password);

      if (authResult != null) {
        // บันทึก tokens และ user profile
        await _saveAuthData(authResult);

        setState(() {
          _isLoggedIn = true;
          _userProfile = authResult['user'];
          _accessToken = authResult['accessToken'];
          _refreshToken = authResult['refreshToken'];
          _tokenExpiry = DateTime.now().add(Duration(hours: 1));
        });

        _showMessage('เข้าสู่ระบบสำเร็จ!');

        // ล้างฟอร์ม
        _usernameController.clear();
        _passwordController.clear();
      } else {
        _showMessage('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง', isError: true);
      }
    } catch (e) {
      _showMessage('เกิดข้อผิดพลาด: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    // ล้างข้อมูล authentication โดยการ clear ทั้งหมด
    await cacheManager.clear();

    setState(() {
      _isLoggedIn = false;
      _userProfile = null;
      _accessToken = null;
      _refreshToken = null;
      _tokenExpiry = null;
    });

    _showMessage('ออกจากระบบแล้ว');
  }

  Future<void> _checkExistingSession() async {
    try {
      // ตรวจสอบ tokens ที่บันทึกไว้
      final accessToken = await cacheManager.get('access_token');
      final refreshToken = await cacheManager.get('refresh_token');
      final userProfile = await cacheManager.get('user_profile');
      final tokenExpiryStr = await cacheManager.get('token_expiry');

      if (accessToken != null && userProfile != null) {
        setState(() {
          _accessToken = accessToken;
          _refreshToken = refreshToken;
          _userProfile = Map<String, dynamic>.from(userProfile);
          _tokenExpiry = tokenExpiryStr != null ? DateTime.parse(tokenExpiryStr) : null;
        });

        // ตรวจสอบว่า token หมดอายุหรือไม่
        if (_tokenExpiry != null && DateTime.now().isAfter(_tokenExpiry!)) {
          if (_refreshToken != null) {
            await _refreshAccessToken();
          } else {
            await _logout();
            _showMessage('Session หมดอายุ กรุณาเข้าสู่ระบบใหม่', isError: true);
            return;
          }
        }

        setState(() {
          _isLoggedIn = true;
        });

        _showMessage('กู้คืน session สำเร็จ');
      }
    } catch (e, stack) {
      // Log and notify so the error isn't silently ignored.
      _showMessage('ไม่สามารถกู้คืน session: $e', isError: true);
      debugPrint('Session restore error: $e\n$stack');
    }
  }

  Future<void> _saveAuthData(Map<String, dynamic> authResult) async {
    if (!_isInitialized) return;

    // บันทึก access token (หมดอายุใน 1 ชั่วโมง)
    await cacheManager.put(
      key: 'access_token',
      value: authResult['accessToken'],
      policy: CachePolicy(maxAge: Duration(hours: 1)),
    );

    // บันทึก refresh token (หมดอายุใน 7 วัน)
    await cacheManager.put(
      key: 'refresh_token',
      value: authResult['refreshToken'],
      policy: CachePolicy(maxAge: Duration(days: 7)),
    );

    // บันทึก user profile (หมดอายุใน 24 ชั่วโมง)
    await cacheManager.put(
      key: 'user_profile',
      value: authResult['user'],
      policy: CachePolicy(maxAge: Duration(hours: 24)),
    );

    // บันทึกเวลาหมดอายุ
    final expiry = DateTime.now().add(Duration(hours: 1));
    await cacheManager.put(
      key: 'token_expiry',
      value: expiry.toIso8601String(),
      policy: CachePolicy(maxAge: Duration(hours: 1)),
    );
  }

  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null || !_isInitialized) {
      _showMessage('ไม่สามารถต่ออายุ token ได้', isError: true);
      return;
    }

    try {
      // จำลองการเรียก refresh token API
      await Future.delayed(Duration(seconds: 1));

      // สร้าง access token ใหม่
      final newAccessToken = _generateToken();
      final newExpiry = DateTime.now().add(Duration(hours: 1));

      // บันทึก token ใหม่
      await cacheManager.put(
        key: 'access_token',
        value: newAccessToken,
        policy: CachePolicy(maxAge: Duration(hours: 1)),
      );

      await cacheManager.put(
        key: 'token_expiry',
        value: newExpiry.toIso8601String(),
        policy: CachePolicy(maxAge: Duration(hours: 1)),
      );

      setState(() {
        _accessToken = newAccessToken;
        _tokenExpiry = newExpiry;
      });

      _showMessage('ต่ออายุ token สำเร็จ');
    } catch (e) {
      _showMessage('ไม่สามารถต่ออายุ token ได้: $e', isError: true);
    }
  }

  Future<void> _clearCache() async {
    try {
      await cacheManager.clear();
      _showMessage('ล้าง cache สำเร็จ');

      // รีเซ็ตสถานะ
      await _logout();
    } catch (e) {
      _showMessage('ไม่สามารถล้าง cache ได้: $e', isError: true);
    }
  }

  Future<List<Map<String, dynamic>>> _getCacheStatus() async {
    final keys = ['access_token', 'refresh_token', 'user_profile', 'token_expiry'];
    final List<Map<String, dynamic>> status = [];

    for (final key in keys) {
      final exists = await cacheManager.exists(key);
      final info = await cacheManager.getEntryInfo(key);

      status.add({
        'key': key,
        'status': exists ? 'มีข้อมูล${info?.remainingTime != null ? " (เหลือ ${_formatDuration(info!.remainingTime!)})" : ""}' : 'ไม่มีข้อมูล',
      });
    }

    return status;
  }

  Map<String, dynamic>? _validateCredentials(String username, String password) {
    // จำลองการตรวจสอบ credentials
    final users = {
      'admin': {
        'password': 'password',
        'user': {
          'id': 1,
          'username': 'admin',
          'name': 'ผู้ดูแลระบบ',
          'email': 'admin@example.com',
          'role': 'Administrator',
          'lastLogin': DateTime.now().subtract(Duration(hours: 2)).toString(),
        }
      },
      'user': {
        'password': '123456',
        'user': {
          'id': 2,
          'username': 'user',
          'name': 'ผู้ใช้ทั่วไป',
          'email': 'user@example.com',
          'role': 'User',
          'lastLogin': DateTime.now().subtract(Duration(minutes: 30)).toString(),
        }
      },
      'demo': {
        'password': 'demo',
        'user': {
          'id': 3,
          'username': 'demo',
          'name': 'บัญชีทดสอบ',
          'email': 'demo@example.com',
          'role': 'Demo User',
          'lastLogin': DateTime.now().subtract(Duration(days: 1)).toString(),
        }
      },
    };

    if (users.containsKey(username) && users[username]!['password'] == password) {
      return {
        'accessToken': _generateToken(),
        'refreshToken': _generateToken(),
        'user': users[username]!['user'],
      };
    }

    return null;
  }

  String _generateToken() {
    final random = Random();
    final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(32, (index) => chars[random.nextInt(chars.length)]).join();
  }

  String _maskedToken(String? token) {
    if (token == null) return '-';
    if (token.length <= 8) return token;
    return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
  }

  String _formatExpiry() {
    if (_tokenExpiry == null) return '-';

    final remaining = _tokenExpiry!.difference(DateTime.now());
    if (remaining.isNegative) {
      return 'หมดอายุแล้ว';
    }

    return '${_formatDuration(remaining)} (${_tokenExpiry!.toString().substring(0, 19)})';
  }

  String _getTokenStatus() {
    if (_tokenExpiry == null) return '-';

    final remaining = _tokenExpiry!.difference(DateTime.now());
    if (remaining.isNegative) {
      return '🔴 หมดอายุแล้ว';
    } else if (remaining.inMinutes < 10) {
      return '🟡 ใกล้หมดอายุ';
    } else {
      return '🟢 ใช้งานได้';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} วัน ${duration.inHours.remainder(24)} ชั่วโมง';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ชั่วโมง ${duration.inMinutes.remainder(60)} นาที';
    } else {
      return '${duration.inMinutes} นาที';
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
