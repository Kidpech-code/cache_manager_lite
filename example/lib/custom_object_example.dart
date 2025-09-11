import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';
import 'dart:convert';

void main() {
  runApp(CustomObjectApp());
}

class CustomObjectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Object Caching Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: CustomObjectExample(),
    );
  }
}

/// **Custom Object Models สำหรับการทดสอบ**
/// แสดงวิธีการสร้าง custom objects ที่สามารถ cache ได้

/// Model สำหรับผู้ใช้
class User {
  final String id;
  final String name;
  final String email;
  final int age;
  final List<String> hobbies;
  final Address address;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.hobbies,
    required this.address,
    required this.createdAt,
  });

  /// Convert object to Map for caching
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'hobbies': hobbies,
      'address': address.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create object from cached Map
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      hobbies: List<String>.from(json['hobbies']),
      address: Address.fromJson(json['address']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}

/// Model สำหรับที่อยู่ (nested object)
class Address {
  final String street;
  final String city;
  final String country;
  final String zipCode;

  Address({
    required this.street,
    required this.city,
    required this.country,
    required this.zipCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'country': country,
      'zipCode': zipCode,
    };
  }

  static Address fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      country: json['country'],
      zipCode: json['zipCode'],
    );
  }

  @override
  String toString() {
    return '$street, $city, $country $zipCode';
  }
}

/// Model สำหรับสินค้า
class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final List<String> tags;
  final ProductSpecs specs;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.tags,
    required this.specs,
    required this.isAvailable,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'tags': tags,
      'specs': specs.toJson(),
      'isAvailable': isAvailable,
    };
  }

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      category: json['category'],
      tags: List<String>.from(json['tags']),
      specs: ProductSpecs.fromJson(json['specs']),
      isAvailable: json['isAvailable'],
    );
  }
}

/// Model สำหรับข้อมูลสเปคสินค้า
class ProductSpecs {
  final String color;
  final String size;
  final double weight;
  final Map<String, dynamic> features;

  ProductSpecs({
    required this.color,
    required this.size,
    required this.weight,
    required this.features,
  });

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'size': size,
      'weight': weight,
      'features': features,
    };
  }

  static ProductSpecs fromJson(Map<String, dynamic> json) {
    return ProductSpecs(
      color: json['color'],
      size: json['size'],
      weight: json['weight'].toDouble(),
      features: Map<String, dynamic>.from(json['features']),
    );
  }
}

class CustomObjectExample extends StatefulWidget {
  @override
  createState() => _CustomObjectExampleState();
}

class _CustomObjectExampleState extends State<CustomObjectExample> {
  late CacheManagerLite cacheManager;
  List<String> operationLogs = [];

  // Cached objects
  User? cachedUser;
  Product? cachedProduct;
  List<User>? cachedUserList;

  @override
  void initState() {
    super.initState();
    _initializeCache();
  }

  void _initializeCache() {
    cacheManager = CacheManagerLite.forIntermediate(
      appType: AppType.ecommerce,
      cacheSize: CacheSize.medium,
      performanceLevel: PerformanceLevel.high,
      enableEncryption: true,
    );
    _addLog('✅ Cache manager initialized for custom objects');
  }

  void _addLog(String message) {
    setState(() {
      operationLogs.insert(0, '${DateTime.now().toString().substring(11, 19)} $message');
      if (operationLogs.length > 20) {
        operationLogs = operationLogs.take(20).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Object Caching'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildOperationButtons(),
              SizedBox(height: 20),
              _buildCachedObjectsDisplay(),
              SizedBox(height: 20),
              _buildLogDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.inventory, size: 48, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              'Custom Object Caching',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'แสดงวิธีการเก็บ custom objects ด้วย toJson/fromJson',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'การดำเนินการ (Operations)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: _createAndCacheUser,
              icon: Icon(Icons.person_add),
              label: Text('Cache User'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            ElevatedButton.icon(
              onPressed: _createAndCacheProduct,
              icon: Icon(Icons.shopping_cart),
              label: Text('Cache Product'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            ElevatedButton.icon(
              onPressed: _createAndCacheUserList,
              icon: Icon(Icons.group),
              label: Text('Cache User List'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
            ElevatedButton.icon(
              onPressed: _retrieveAllCachedObjects,
              icon: Icon(Icons.refresh),
              label: Text('Retrieve All'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            ElevatedButton.icon(
              onPressed: _clearAllCache,
              icon: Icon(Icons.clear_all),
              label: Text('Clear Cache'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCachedObjectsDisplay() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cached Objects',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            if (cachedUser != null) ...[
              _buildUserCard(cachedUser!),
              SizedBox(height: 8),
            ],
            if (cachedProduct != null) ...[
              _buildProductCard(cachedProduct!),
              SizedBox(height: 8),
            ],
            if (cachedUserList != null) ...[
              _buildUserListCard(cachedUserList!),
              SizedBox(height: 8),
            ],
            if (cachedUser == null && cachedProduct == null && cachedUserList == null)
              Text(
                'ยังไม่มี objects ที่ถูก cache',
                style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.green),
              SizedBox(width: 8),
              Text('User Object', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text('ID: ${user.id}'),
          Text('Name: ${user.name}'),
          Text('Email: ${user.email}'),
          Text('Age: ${user.age}'),
          Text('Hobbies: ${user.hobbies.join(", ")}'),
          Text('Address: ${user.address}'),
          Text('Created: ${user.createdAt.toString().substring(0, 19)}'),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.orange),
              SizedBox(width: 8),
              Text('Product Object', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text('ID: ${product.id}'),
          Text('Name: ${product.name}'),
          Text('Price: \$${product.price.toStringAsFixed(2)}'),
          Text('Category: ${product.category}'),
          Text('Tags: ${product.tags.join(", ")}'),
          Text('Available: ${product.isAvailable ? "Yes" : "No"}'),
          Text('Specs: ${product.specs.color}, ${product.specs.size}, ${product.specs.weight}kg'),
        ],
      ),
    );
  }

  Widget _buildUserListCard(List<User> users) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        border: Border.all(color: Colors.purple),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.group, color: Colors.purple),
              SizedBox(width: 8),
              Text('User List (${users.length} users)', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          ...users.take(3).map((user) => Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('• ${user.name} (${user.email})'),
              )),
          if (users.length > 3) Text('...และอีก ${users.length - 3} คน', style: TextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildLogDisplay() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operation Logs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: operationLogs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      operationLogs[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // การดำเนินการ Cache Operations
  // ===============================

  Future<void> _createAndCacheUser() async {
    _addLog('🔹 Creating and caching User object...');

    try {
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: 'John Doe',
        email: 'john.doe@example.com',
        age: 28,
        hobbies: ['Photography', 'Traveling', 'Reading'],
        address: Address(
          street: '123 Main Street',
          city: 'Bangkok',
          country: 'Thailand',
          zipCode: '10100',
        ),
        createdAt: DateTime.now(),
      );

      // Cache the User object using toJson()
      await cacheManager.putForHours(
        key: 'cached_user',
        value: user.toJson(), // Convert to Map
        hours: 2,
        encryptionKey: 'user-encryption-key-2024',
      );

      setState(() {
        cachedUser = user;
      });

      _addLog('✅ User object cached successfully');
      _addLog('📄 User: ${user.name} (${user.email})');
    } catch (e) {
      _addLog('❌ Failed to cache User: $e');
    }
  }

  Future<void> _createAndCacheProduct() async {
    _addLog('🔹 Creating and caching Product object...');

    try {
      final product = Product(
        id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
        name: 'MacBook Pro M3',
        price: 1999.99,
        category: 'Electronics',
        tags: ['laptop', 'apple', 'professional', 'M3'],
        specs: ProductSpecs(
          color: 'Space Gray',
          size: '14-inch',
          weight: 1.55,
          features: {
            'processor': 'Apple M3 Pro',
            'memory': '16GB',
            'storage': '512GB SSD',
            'display': 'Liquid Retina XDR',
          },
        ),
        isAvailable: true,
      );

      // Cache the Product object using toJson()
      await cacheManager.putForDays(
        key: 'cached_product',
        value: product.toJson(), // Convert to Map
        days: 1,
        encryptionKey: 'product-encryption-key-2024',
      );

      setState(() {
        cachedProduct = product;
      });

      _addLog('✅ Product object cached successfully');
      _addLog('📄 Product: ${product.name} (\$${product.price})');
    } catch (e) {
      _addLog('❌ Failed to cache Product: $e');
    }
  }

  Future<void> _createAndCacheUserList() async {
    _addLog('🔹 Creating and caching User List...');

    try {
      final users = [
        User(
          id: 'user_1',
          name: 'Alice Johnson',
          email: 'alice@example.com',
          age: 25,
          hobbies: ['Coding', 'Gaming'],
          address: Address(street: '456 Oak St', city: 'Chiang Mai', country: 'Thailand', zipCode: '50000'),
          createdAt: DateTime.now().subtract(Duration(days: 1)),
        ),
        User(
          id: 'user_2',
          name: 'Bob Smith',
          email: 'bob@example.com',
          age: 32,
          hobbies: ['Cooking', 'Hiking'],
          address: Address(street: '789 Pine Ave', city: 'Phuket', country: 'Thailand', zipCode: '83000'),
          createdAt: DateTime.now().subtract(Duration(hours: 12)),
        ),
        User(
          id: 'user_3',
          name: 'Carol White',
          email: 'carol@example.com',
          age: 29,
          hobbies: ['Dancing', 'Painting'],
          address: Address(street: '321 Elm Dr', city: 'Pattaya', country: 'Thailand', zipCode: '20150'),
          createdAt: DateTime.now().subtract(Duration(hours: 6)),
        ),
      ];

      // Convert list of objects to list of maps
      final userMaps = users.map((user) => user.toJson()).toList();

      // Cache the User list
      await cacheManager.putUntilEndOfDay(
        key: 'cached_user_list',
        value: userMaps, // List of Maps
        encryptionKey: 'user-list-encryption-key-2024',
      );

      setState(() {
        cachedUserList = users;
      });

      _addLog('✅ User list cached successfully');
      _addLog('📄 Cached ${users.length} users');
    } catch (e) {
      _addLog('❌ Failed to cache User list: $e');
    }
  }

  Future<void> _retrieveAllCachedObjects() async {
    _addLog('🔍 Retrieving all cached objects...');

    try {
      // Retrieve User
      final userMap = await cacheManager.get<Map<String, dynamic>>('cached_user');
      if (userMap != null) {
        final user = User.fromJson(userMap);
        setState(() {
          cachedUser = user;
        });
        _addLog('✅ Retrieved User: ${user.name}');
      } else {
        setState(() {
          cachedUser = null;
        });
        _addLog('ℹ️ No cached User found');
      }

      // Retrieve Product
      final productMap = await cacheManager.get<Map<String, dynamic>>('cached_product');
      if (productMap != null) {
        final product = Product.fromJson(productMap);
        setState(() {
          cachedProduct = product;
        });
        _addLog('✅ Retrieved Product: ${product.name}');
      } else {
        setState(() {
          cachedProduct = null;
        });
        _addLog('ℹ️ No cached Product found');
      }

      // Retrieve User List
      final userListMaps = await cacheManager.get<List<dynamic>>('cached_user_list');
      if (userListMaps != null) {
        final users = userListMaps.cast<Map<String, dynamic>>().map((map) => User.fromJson(map)).toList();
        setState(() {
          cachedUserList = users;
        });
        _addLog('✅ Retrieved User list: ${users.length} users');
      } else {
        setState(() {
          cachedUserList = null;
        });
        _addLog('ℹ️ No cached User list found');
      }
    } catch (e) {
      _addLog('❌ Failed to retrieve objects: $e');
    }
  }

  Future<void> _clearAllCache() async {
    _addLog('🗑️ Clearing all cached objects...');

    try {
      await cacheManager.clear();

      setState(() {
        cachedUser = null;
        cachedProduct = null;
        cachedUserList = null;
      });

      _addLog('✅ All cache cleared successfully');
    } catch (e) {
      _addLog('❌ Failed to clear cache: $e');
    }
  }
}
