import 'package:chess_game/components/square.dart';
import 'package:chess_game/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Chess Game Integration Test', () {
    testWidgets('Play a full game', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Example: Tap a white pawn and move it forward
      await tester.tap(find.byType(Square).at(48)); // Example position
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Square).at(32)); // Example destination
      await tester.pumpAndSettle();

      // Add assertions to verify the move was successful.
      // For example, check that the piece is now at the new position.
    });
  });
}
