part of 'viewmodel.dart';

@protected
class ViewModelModule {
  ViewModelModule._();

  /// Stores all [ViewModel] registered with a [ViewModelMixin] or [MultiViewModelMixin]
  static final Map<String, ViewModel> _viewModels = {};


  /// Function to register a [ViewModel] in [ViewModelModule].
  /// Registering makes [ViewModel] accessible for the widgets.
  static List<String> registerViewModels(Iterable<ViewModel> viewModels){
    final Random random = Random();
    String viewModelIdentifier = '';
    List<String> viewModelIdentifiers = [];
    for(ViewModel viewModel in viewModels) {
      while (_viewModels.keys.contains(viewModelIdentifier)) {
        viewModelIdentifier = random.nextInt(0x7fffffff).toString();
      }
      _viewModels.addAll({viewModelIdentifier: viewModel});
      viewModel.registerCount++;
      viewModelIdentifiers.add(viewModelIdentifier);
    }
    return viewModelIdentifiers;
  }

  /// Function to access the [ViewModel] registered by a [ViewModelMixin] or [MultiViewModelMixin]
  static T getViewModel<T extends ViewModel>(String viewModelIdentifier){
    final T? viewModel = _viewModels[viewModelIdentifier] as T?;
    if(viewModel==null){
      throw 'ViewModel getter called without adding ViewModel first';
    }
    return viewModel;

  }


  /// Function to destroy [ViewModel] when the owner widget of the [ViewModel] disposes
  static destroyViewModels(Iterable<String> viewModelIdentifiers){
    for(String viewModelIdentifier in viewModelIdentifiers) {
      _viewModels[viewModelIdentifier]?.registerCount--;
      if (_viewModels[viewModelIdentifier]?.registerCount == 0) {
        _viewModels[viewModelIdentifier]?.destroy();
      }
      _viewModels.remove(viewModelIdentifier);
    }
  }
}

