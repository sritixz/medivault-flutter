import 'package:flutter_test/flutter_test.dart';
import 'package:medivault_mobile/main.dart';

void main() {
  testWidgets('MediVaultApp initial smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediVaultApp());
    expect(find.text('Vikram Sharma'), findsOneWidget);
    expect(find.text('1-Tap Emergency SOS'), findsOneWidget);
    expect(find.text('Essential Healthcare'), findsOneWidget);
    expect(find.text('Offers & Preventive Care'), findsOneWidget);
  });
}
