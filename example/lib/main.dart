import 'package:flutter/material.dart';

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
            onTap: () => _showDemo(context, 'Basic Usage'),
          ),
          _ExampleCard(
            title: 'Advanced Features',
            description: 'Encryption, expiration, and monitoring',
            onTap: () => _showDemo(context, 'Advanced Features'),
          ),
          _ExampleCard(
            title: 'Network Caching',
            description: 'HTTP request caching with Dio',
            onTap: () => _showDemo(context, 'Network Caching'),
          ),
        ],
      ),
    );
  }

  void _showDemo(BuildContext context, String demo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(demo),
        content: Text('This would show the $demo example'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
