import 'package:flutter/foundation.dart';
part 'shared_repository.dart';

abstract class ViewModel {
  @protected
  int registerCount = 0;

  void init();

  void destroy();
}
