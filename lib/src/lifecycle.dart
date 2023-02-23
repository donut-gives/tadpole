import 'package:flutter/widgets.dart';

typedef LifeCycleOwner = ValueNotifier<LifeCycle>;

mixin LifeCycleOwnerMixin<T extends StatefulWidget> on State<T> {
  final LifeCycleOwner _lifeCycleOwner = ValueNotifier(LifeCycle.unborn);
  LifeCycleOwner get lifeCycleOwner => _lifeCycleOwner;

  @override
  void initState() {
    _lifeCycleOwner.value = LifeCycle.awake;
    super.initState();
  }

  @override
  void activate() {
    _lifeCycleOwner.value = LifeCycle.awake;
    super.activate();
  }

  @override
  void deactivate(){
    _lifeCycleOwner.value = LifeCycle.asleep;
    super.deactivate();
  }


  @override
  void dispose() {
    _lifeCycleOwner.value = LifeCycle.dead;
    super.dispose();
  }
}

enum LifeCycle {
  unborn,
  awake,
  asleep,
  dead
}

