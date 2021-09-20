import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// 30fps default
Duration timeTickerDuration = Duration(milliseconds: 1000 ~/ 30);

mixin TimerTickerProviderMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  Ticker? _ticker;

  @override
  Ticker createTicker(
    TickerCallback onTick,
  ) {
    _ticker ??= TimerTicker(onTick);

    return _ticker!;
  }

  @override
  void didChangeDependencies() {
    _ticker?.muted = !TickerMode.of(context);
    super.didChangeDependencies();
  }
}

Timer? t;

void Function(Timer) callBack = (timer) {
  var list = callbacks.entries;
  for (int i = 0; i < list.length; i++) {
    var key = list.elementAt(i).key;
    var value = list.elementAt(i).value;
    if (SchedulerBinding.instance!.framesEnabled) {
      key(Duration(
          milliseconds: DateTime.now().millisecondsSinceEpoch -
              value._tickerStartTime!.millisecondsSinceEpoch));
    } else {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        if (value.isActive) {
          value.scheduleTick(rescheduling: true);
        }
      });
    }
  }
};

Map<TickerCallback, TimerTicker> callbacks = {};

class TimerTicker extends Ticker {
  late TickerCallback? _callback;

  DateTime? _tickerStartTime;

  TimerTicker(TickerCallback onTick) : super(onTick) {
    _callback = onTick;
  }

  @override
  TickerFuture start() {
    _tickerStartTime = DateTime.now();
    return super.start();
  }

  @override
  void stop({bool canceled = false}) {
    callbacks.remove(_callback);
    if (callbacks.length == 0) {
      t?.cancel();
      t = null;
    }
    super.stop(canceled: canceled);
  }

  @override
  void scheduleTick({bool rescheduling = false}) {
    assert(!scheduled);
    assert(shouldScheduleTick);
    callbacks[_callback!] = this;
    t ??= Timer.periodic(timeTickerDuration, callBack);
  }

  @override
  void unscheduleTick() {
    callbacks.remove(_callback);
    if (callbacks.length == 0) {
      t?.cancel();
      t = null;
    }
  }
}
