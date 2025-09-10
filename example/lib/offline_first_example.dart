import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

/// Example showing offline-first approach.
/// ตัวอย่างแสดงแนวทางออฟไลน์เป็นหลัก
class OfflineFirstExample extends StatefulWidget {
  const OfflineFirstExample({super.key});

  @override
  State<OfflineFirstExample> createState() => _OfflineFirstExampleState();
}

class _OfflineFirstExampleState extends State<OfflineFirstExample> {
  late final CacheManagerLite cacheManager;
  Map<String, dynamic>? userData;
  bool isLoading = false;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    cacheManager = CacheManagerLite.forBeginner();
    loadUserData();
  }

  Future<void> loadUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Try to load from cache first
      // ลองโหลดจากแคชก่อน
      final cachedData = await cacheManager.get('user_data');
      if (cachedData != null) {
        setState(() {
          userData = cachedData;
          isLoading = false;
        });
      }

      // Then try to fetch fresh data
      // จากนั้นลองดึงข้อมูลใหม่
      final freshData = await cacheManager.getJson(
        'https://jsonplaceholder.typicode.com/users/1',
        policy: CachePolicy(maxAge: Duration(hours: 6)),
      );

      // Cache the fresh data with a specific key
      // แคชข้อมูลใหม่ด้วยคีย์เฉพาะ
      await cacheManager.put(
        key: 'user_data',
        value: freshData,
        policy: CachePolicy(maxAge: Duration(days: 1)),
      );

      setState(() {
        userData = freshData;
        isLoading = false;
        isOffline = false;
      });
    } catch (e) {
      // If network fails, use cached data
      // หากเครือข่ายล้มเหลว ใช้ข้อมูลที่แคชไว้
      final cachedData = await cacheManager.get('user_data');
      setState(() {
        if (cachedData != null) {
          userData = cachedData;
          isOffline = true;
        }
        isLoading = false;
      });

      if (cachedData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No internet and no cached data available')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline-First Example'),
        backgroundColor: isOffline ? Colors.orange : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isOffline)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '📱 Offline Mode - Showing cached data',
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 16),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (userData != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Information',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 16),
                      _buildInfoCard('Name', userData!['name']),
                      _buildInfoCard('Email', userData!['email']),
                      _buildInfoCard('Phone', userData!['phone']),
                      _buildInfoCard('Website', userData!['website']),
                      _buildInfoCard('Company', userData!['company']['name']),
                    ],
                  ),
                ),
              )
            else
              Center(child: Text('No data available')),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: loadUserData,
                    child: Text('Refresh Data'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await cacheManager.clear();
                      setState(() {
                        userData = null;
                        isOffline = false;
                      });
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Cache cleared')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Clear Cache'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, dynamic value) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            Expanded(
              child: Text(
                value?.toString() ?? 'N/A',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
