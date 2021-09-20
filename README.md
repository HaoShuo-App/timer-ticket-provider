# interval_ticker_provider

interval ticker provider

## Getting Started

```dart
import 'package:interval_ticker_provider/interval_ticker_provider.dart';



timeTickerDuration = Duration(milliseconds: 1000 ~/ 30);


class _HomeAppState extends State<HomeApp> with TimerTickerProviderMixin {

  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

```

