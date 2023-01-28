part of 'context_utils.dart';

class SharedViewModelRepository {
  SharedViewModelRepository._();

  static final Map<String, ViewModel> _viewModels = {};


  /// fetches the [ViewModel] without context
  @protected
  static K? requestViewModel<K extends ViewModel>(String key) {
    ViewModel? viewModel = _viewModels[key];
    if (viewModel is! K) {
      return null;
    }
    return viewModel;
  }

  /// claims a [key] for a [ViewModel] instance
  /// Should always be followed by [disclaim] unless the [ViewModel] has
  /// application level scope
  static K claimViewModel<K extends ViewModel>(
      String key, K Function() factory) {
    K? vm = requestViewModel<K>(key);
    if (vm == null) {
      vm = factory()..init();
      _viewModels.addAll({key: vm});
    }
    return vm;
  }

  /// disclaims the [key] from a [ViewModel] instance and calls [ViewModel.destroy]
  /// Should always be followed by [disclaim] unless the [ViewModel] has
  /// application level scope
  static K? disclaim<K extends ViewModel>(String key) {
    K? vm = requestViewModel<K>(key);
    if (vm != null) {
      _viewModels.removeWhere((k, value) => k == key);
      vm.destroy();
    }
    return vm;
  }
}
