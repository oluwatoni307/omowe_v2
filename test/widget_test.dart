// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:omowe_v2/main.dart';
import 'package:omowe_v2/app_providers.dart';
import 'package:omowe_v2/Service/ingest/fakeIngest.dart';
import 'package:omowe_v2/Service/storage/FakeStorage.dart';

void main() {
  testWidgets('launches the library with an empty storage', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(FakeStorageService()),
          ingestServiceProvider.overrideWithValue(FakeIngestService()),
        ],
        child: const OmoweApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your library is empty.'), findsOneWidget);
  });
}
