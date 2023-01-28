import 'package:flutter/widgets.dart';

typedef LifeCycleOwner = ValueNotifier<LifeCycle>;

mixin LifeCycleOwnerMixin<T extends StatefulWidget> on State<T> {
  final LifeCycleOwner lifeCycleOwner = ValueNotifier(LifeCycle.unborn);

  @override
  void initState() {
    lifeCycleOwner.value = LifeCycle.awake;
    super.initState();
  }

  @override
  void activate() {
    lifeCycleOwner.value = LifeCycle.awake;
    super.activate();
  }

  @override
  void deactivate(){
    lifeCycleOwner.value = LifeCycle.asleep;
    super.deactivate();
  }


  @override
  void dispose() {
    lifeCycleOwner.value = LifeCycle.dead;
    super.dispose();
  }
}

enum LifeCycle {
  unborn,
  awake,
  asleep,
  dead
}

