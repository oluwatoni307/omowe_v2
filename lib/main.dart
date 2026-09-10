import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'reader/screens/library_screen.dart';
import 'theme/omowe_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const ProviderScope(child: OmoweApp()));
}

class OmoweApp extends StatelessWidget {
  const OmoweApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omowe',
      theme: OmoweTheme.light,
      debugShowCheckedModeBanner: false,
      home: const LibraryScreen(),
    );
  }
}
