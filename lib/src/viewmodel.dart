import 'dart:math';
import 'package:flutter/foundation.dart';

import 'viewmodel_mixins.dart';

part 'viewmodel_module.dart';

abstract class ViewModel {
  @protected
  int registerCount = 0;

  void destroy();
}

