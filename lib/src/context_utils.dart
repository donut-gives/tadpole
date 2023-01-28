import 'package:viumodel/src/lifecycle.dart';

import 'viewmodel_exceptions.dart';
import 'viewmodel.dart';
import 'package:flutter/widgets.dart';

part 'viewmodel_mixin.dart';
part 'register_viewmodel_mixin.dart';

T? _findViewModelInAncestor<T extends ViewModel>(BuildContext context) {
  RegisterViewModelMixin? state = context.findAncestorStateOfType<RegisterViewModelMixin>();
  T? viewModel = state?.getViewModel<T>();
  return viewModel;
}