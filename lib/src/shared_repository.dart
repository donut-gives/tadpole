part of 'viewmodel.dart';

class SharedRepository {
  SharedRepository._();

  static final Map<String, ViewModel> _viewModels = {};


  static ViewModel? requestViewModel(String key) {
   ViewModel? viewModel = _viewModels[key];
   return viewModel;
  }

  static ViewModel claimViewModel(String key, ViewModel Function() factory) {
    ViewModel? vm = requestViewModel(key);
    if (vm == null) {
      vm = factory()..init();
      _viewModels.addAll({key: vm});
    }
    vm.registerCount++;
    return vm;
  }

  static ViewModel? disclaim(String key) {
    ViewModel? vm = requestViewModel(key);
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