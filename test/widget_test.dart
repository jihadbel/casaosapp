import 'package:flutter_test/flutter_test.dart';
import 'package:casaosapp/main.dart';

void main() {
  testWidgets('CasaOSApp initial screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CasaOSApp());
    expect(find.text('CasaOS Cloud'), findsOneWidget);
    // Advance past the 2.2s discovery timer and cancel any animation frame
    await tester.pump(const Duration(milliseconds: 3000));
  });
}
