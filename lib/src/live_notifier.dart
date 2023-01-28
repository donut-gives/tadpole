import 'package:flutter/widgets.dart';
import 'package:viumodel/src/lifecycle.dart';



class LiveNotifier<T> extends ValueNotifier<T> {
  LiveNotifier(super.value);

  LifeCycle _state = LifeCycle.unborn;
  LifeCycle get state => _state;

  observe(LifeCycleOwner lifeCycleOwner, Function() reaction){
    lifeCycleOwner.addListener(() {
      _state = lifeCycleOwner.value;
      switch(lifeCycleOwner.value) {
        case LifeCycle.unborn:
          break;
        case LifeCycle.awake:
          addListener(reaction);
          break;
        case LifeCycle.asleep:
          removeListener(reaction);
          break;
        case LifeCycle.dead:
          removeListener(reaction);
          break;
      }
    });
  }
}