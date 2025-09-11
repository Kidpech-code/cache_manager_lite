import 'package:flutter/material.dart';
import 'beginner_example.dart';
import 'custom_object_example.dart';
import 'data_security_example.dart';
import 'user_level_example.dart';
import 'cache_expiration_example.dart';
import 'auth_example.dart';

/// Entry point for cache manager lite example app
void main() {
  runApp(const CacheManagerExampleApp());
}

/// Main example app demonstrating cache manager lite
class CacheManagerExampleApp extends StatelessWidget {
  const CacheManagerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cache Manager Lite Examples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

/// Home page showing available examples
class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cache Manager Lite Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Choose an example to run:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            title: 'Basic Usage',
            description: 'Simple cache operations for beginners',
            icon: Icons.school,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CacheDemo()),
            ),
          ),
          _ExampleCard(
            title: 'Custom Objects',
            description: 'Cache custom objects with toJson/fromJson',
            icon: Icons.inventory,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomObjectExample()),
            ),
          ),
          _ExampleCard(
            title: 'User Levels',
            description: 'Different configurations for user skill levels',
            icon: Icons.people,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserLevelExample()),
            ),
          ),
          _ExampleCard(
            title: 'Data Security',
            description: 'Encryption and secure data storage',
            icon: Icons.security,
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataSecurityExample()),
            ),
          ),
          _ExampleCard(
            title: 'Cache Expiration',
            description: 'Advanced expiration management',
            icon: Icons.timer,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CacheExpirationExample()),
            ),
          ),
          _ExampleCard(
            title: 'Authentication',
            description: 'User authentication with secure caching',
            icon: Icons.login,
            color: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthenticationExample()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
