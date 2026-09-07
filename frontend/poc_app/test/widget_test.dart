import 'package:flutter_test/flutter_test.dart';

import 'package:poc_app/main.dart';

void main() {
  testWidgets('App builds and shows the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PocApp());
    await tester.pump();

    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
