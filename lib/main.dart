import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/providers/theme_provider.dart';
import 'core/error/error_handler.dart';
import 'widgets/video_loading_screen.dart';
import 'widgets/asset_debug_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // === Debug asset loading ===
  try {
    final ByteData bytes = await rootBundle.load('algbra-assets/audio/wagtail-chirp4.mp3');
    print('Audio file loaded, bytes length: ${bytes.lengthInBytes}');
  } catch (e) {
    print('RootBundle asset load error: $e');
  }
  // === End Debug ===

  // Initialize global error handling
  GlobalErrorHandler.initialize();

  // Remove the hash from URLs on web
  usePathUrlStrategy();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: AngryWagtailApp(),
    ),
  );
}

class AngryWagtailApp extends StatefulWidget {
  const AngryWagtailApp({Key? key}) : super(key: key);

  @override
  State<AngryWagtailApp> createState() => _AngryWagtailAppState();
}

class _AngryWagtailAppState extends State<AngryWagtailApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() async {
    // Place real initialization logic here!
    await Future.delayed(const Duration(seconds: 3)); // Simulate loading
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Wrap your loading screen in MaterialApp for Directionality!
      return MaterialApp(
        // home: const VideoLoadingScreen(),
        home: AssetDebugScreen(),
        debugShowCheckedModeBanner: false,
      );
    }
    // Your real app after loading
    return const App();
  }
}
