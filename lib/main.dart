import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  void _handleIncomingLinks() {
    _appLinks.uriLinkStream.listen(_processUri);
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _processUri(uri);
    });
  }

  void _processUri(Uri uri) {
    print('📥 Received URI: $uri');

    if (uri.path == '/ad') {
      final categoryId = uri.queryParameters['categoryId'];
      final adId = uri.queryParameters['adId'];

      if (categoryId != null && adId != null) {
        Get.toNamed('/ad/$adId', arguments: {'categoryId': categoryId});
      }
    } else if (uri.path == '/profile') {
      final userId = uri.queryParameters['userId'];

      if (userId != null) {
        Get.toNamed('/profile/$userId');
      }
    } else {
      print('❓ Unhandled URI');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(title: 'Deep Link App', initialRoute: '/', getPages: [
      GetPage(name: '/', page: () => HomeScreen()),
      GetPage(name: '/ad/:id', page: () => AdDetailsScreen()),
      GetPage(name: '/profile/:id', page: () => ProfileScreen()),
    ]);
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الرئيسية')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                final link = Uri.https('myapp.com', '/ad', {
                  'categoryId': '5',
                  'adId': '101',
                });
                Share.share(link.toString());
              },
              child: Text('مشاركة إعلان'),
            ),
            ElevatedButton(
              onPressed: () {
                final link = Uri.https('myapp.com', '/profile', {
                  'userId': '123',
                });
                Share.share(link.toString());
              },
              child: Text('مشاركة ملف شخصي'),
            ),
            ElevatedButton(
              onPressed: () {
                final link = Uri.https('myapp.com', '/unknown', {});
                Share.share(link.toString());
              },
              child: Text('مشاركة رابط غير معروف'),
            ),
          ],
        ),
      ),
    );
  }
}

class AdDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adId = Get.parameters['id'];
    final categoryId = Get.arguments['categoryId'];

    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل إعلان')),
      body: Center(
        child: Text('Ad ID: $adId\nCategory: $categoryId'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Get.parameters['id'];

    return Scaffold(
      appBar: AppBar(title: Text('الملف الشخصي')),
      body: Center(
        child: Text('User ID: $userId'),
      ),
    );
  }
}
