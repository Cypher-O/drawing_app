import 'package:flutter_test/flutter_test.dart';
import 'package:drawing_app/utils/imports/general_import.dart';

class TestTickerProvider extends StatefulWidget {
  final Widget Function(BuildContext context, TickerProvider vsync) builder;
  const TestTickerProvider({super.key, required this.builder});

  @override
  TestTickerProviderState createState() => TestTickerProviderState();
}

class TestTickerProviderState extends State<TestTickerProvider> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }
}

void main() {
  group('Drawing App Widgets', () {
    late BaseModel viewModel;

    Widget buildTestWidget(Widget Function(BuildContext, BaseModel) builder) {
      return TestTickerProvider(
        builder: (context, vsync) {
          viewModel = BaseModel(vsync);
          return MaterialApp(
            home: Scaffold(
              body: builder(context, viewModel),
            ),
          );
        },
      );
    }

    testWidgets('buildColorPalette renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget((context, vm) => buildColorPalette(context, vm)));

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('buildBackgroundColorPalette renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget((context, vm) => buildBackgroundColorPalette(context, vm)));

      expect(find.byType(AnimatedContainer), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('buildVerticalStrokeSlider renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget((context, vm) => buildVerticalStrokeSlider(vm)));

      expect(find.byType(RotatedBox), findsNWidgets(2));
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(CustomIconButton), findsOneWidget);
    });
  });
}