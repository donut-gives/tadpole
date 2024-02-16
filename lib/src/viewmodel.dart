import 'package:flutter/cupertino.dart';
import 'package:tadpole/src/lifecycle.dart';

abstract class ViewModel {
  final LifeCycleOwner _lifeCycleOwner = ValueNotifier(LifeCycle.unborn);
  LifeCycleOwner get lifeCycleOwner => _lifeCycleOwner;

  void init(){
    _lifeCycleOwner.value = LifeCycle.awake;
  }

  void destroy(){
    _lifeCycleOwner.value = LifeCycle.dead;
  }
}
