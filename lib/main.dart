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
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null &&
          uri.pathSegments.isNotEmpty &&
          uri.pathSegments.first == 'ad') {
        final adId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
        if (adId != null) {
          Get.toNamed('/ad/$adId');
        }
      }
    });

    _appLinks.getInitialLink().then((uri) {
      if (uri != null &&
          uri.pathSegments.isNotEmpty &&
          uri.pathSegments.first == 'ad') {
        final adId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
        if (adId != null) {
          Get.toNamed('/ad/$adId');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Deep Link App',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/ad/:id', page: () => AdDetailsScreen()),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adId = '12345';
    final link = 'https://myapp.com/ad/$adId';

    return Scaffold(
      appBar: AppBar(title: Text('الرئيسية')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Share.share(link),
          child: Text('مشاركة إعلان'),
        ),
      ),
    );
  }
}

class AdDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adId = Get.parameters['id'] ?? 'غير معروف';

    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل الإعلان')),
      body: Center(
        child: Text('رقم الإعلان: $adId'),
      ),
    );
  }
}
