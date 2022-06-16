import 'dart:math';
import 'package:flutter/foundation.dart';

part 'viewmodel_module.dart';

abstract class ViewModel {
  @protected
  int registerCount = 0;

  void destroy();
}
