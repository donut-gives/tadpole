import 'package:tadpole/src/viewmodel_exceptions.dart';
import 'package:tadpole/src/viewmodel.dart';
import 'package:flutter/widgets.dart';

part 'viewmodel_mixin.dart';
part 'register_viewmodel_mixin.dart';
part 'shared_repository.dart';

T? _findViewModelInAncestor<T extends ViewModel>(BuildContext context) {
  RegisterViewModelMixin? state = context.findAncestorStateOfType<RegisterViewModelMixin>();
  T? viewModel = state?.getViewModel<T>();
  return viewModel;
}