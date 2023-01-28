part of 'viewmodel.dart';

class SharedViewModelRepository {
  SharedViewModelRepository._();

  static final Map<String, ViewModel> _viewModels = {};


  static K? requestViewModel<K extends ViewModel>(String key) {
   ViewModel? viewModel = _viewModels[key];
   if (viewModel is! K) {
     return null;
   }
   return viewModel;
  }

  static K claimViewModel<K extends ViewModel>(String key, K Function() factory) {
    K? vm = requestViewModel<K>(key);
    if (vm == null) {
      vm = factory()..init();
      _viewModels.addAll({key: vm});
    }
    vm.registerCount++;
    return vm;
  }

  static K? disclaim<K extends ViewModel>(String key) {
    K? vm = requestViewModel<K>(key);
    if (vm != null) {
      vm.registerCount--;
      if (vm.registerCount==0) {
        _viewModels.removeWhere((k, value) => k==key);
        vm.destroy();
      }
    }
    return vm;
  }
}