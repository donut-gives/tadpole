part of 'viewmodel.dart';

@protected
class ViewModelModule {
  ViewModelModule._();

  /// Stores all [ViewModel] registered with a [ViewModelMixin] or [MultiViewModelMixin]
  static final Map<String, ViewModel> _viewModels = {};

  /// Stores shared [ViewModel]'s key and their identifiers
  static final Map<String, List<String>> _sharedViewModelIds = {};

  /// Function to register a [ViewModel] in [ViewModelModule].
  /// Registering makes [ViewModel] accessible for the widgets.
  static String registerViewModel<T extends ViewModel>(T viewModel, [String? key]){
    final Random random = Random();
    String viewModelIdentifier = '';
    while (_viewModels.keys.contains(viewModelIdentifier)) {
      viewModelIdentifier = random.nextInt(0x7fffffff).toString();
    }
    _viewModels.addAll({viewModelIdentifier: viewModel});
    viewModel.registerCount++;
    if(key!=null){
      _registerIdWithKey(key, viewModelIdentifier);
    }
    return viewModelIdentifier;
  }

  /// Function to access the [ViewModel] registered by a [ViewModelMixin] or [MultiViewModelMixin]
  static ViewModel getViewModel(String viewModelIdentifier){
    final viewModel = _viewModels[viewModelIdentifier];
    if(viewModel==null){
      throw 'ViewModel getter called without adding ViewModel first';
    }
    return viewModel;
  }

  /// Function to destroy [ViewModel] when the owner widget of the [ViewModel] disposes
  static destroyViewModels(Iterable<String> viewModelIdentifiers, [Map<String, String>? keyAndIdPairs]){
    for(String viewModelIdentifier in viewModelIdentifiers) {
      _viewModels[viewModelIdentifier]?.registerCount--;
      if (_viewModels[viewModelIdentifier]?.registerCount == 0) {
        _viewModels[viewModelIdentifier]?.destroy();
      }
      _viewModels.remove(viewModelIdentifier);
    }
    if(keyAndIdPairs!=null) {
      _deregisterIdsWithKeys(keyAndIdPairs);
    }
  }

  static _registerIdWithKey(String key, String id){
    if(_sharedViewModelIds[key]!=null) {
      _sharedViewModelIds[key]!.add(id);
    } else {
      _sharedViewModelIds.addAll({key: [id]});
    }
  }

  static T? getViewModelFromKey<T extends ViewModel>(String key){
    return _sharedViewModelIds[key]==null?null:_viewModels[_sharedViewModelIds[key]!.first] as T;
  }

  static _deregisterIdsWithKeys(Map<String, String> keyAndIdPairs){
    for(String key in keyAndIdPairs.keys) {
      _sharedViewModelIds[key]!.remove(keyAndIdPairs[key]);
    }
  }

}


