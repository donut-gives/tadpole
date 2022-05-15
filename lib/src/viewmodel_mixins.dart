import 'package:flutter/widgets.dart';

import 'viewmodel.dart';

T? _findViewModel<T extends ViewModel>(BuildContext context) {
  T? viewModel;
  // Checks for ViewModel in ancestral ViewModelMixins
  ViewModelMixin<T>? viewModelMixin = context.findAncestorStateOfType<ViewModelMixin<T>>();
  viewModel = viewModelMixin?.viewModel;
  // Checks for ViewModel in ancestral MultiViewModelMixins
  if (viewModel == null) {
    MultiViewModelMixin? multiViewModelMixin = context.findAncestorStateOfType<MultiViewModelMixin>();
    viewModel = multiViewModelMixin?.getViewModel<T>();
  }
  return viewModel;
}


/// Used to find [ViewModel] in ancestral [StatefulWidget]
/// 
/// Example: 
/// class Screen extends StatelessWidget with ViewModelProviderMixin{
///   @override
///   void build(BuildContext context){
///     final viewModel = getViewModel<ScreenViewModel>(context);
///     // use ViewModel
///     return Widget();
///   }
/// }
mixin ViewModelProviderMixin on Widget {
  T getViewModel<T>(BuildContext context){
    T? viewModel = _findViewModel(context);
    if(viewModel==null){
      throw 'ViewModel not found';
    }
    return viewModel;
  }
}

/// Used to register single [ViewModel] in a [State]
/// call [registerViewModel] inside [initState]
mixin ViewModelMixin<T extends ViewModel> on State {
  late final String _viewModelIdentifier;

  void registerViewModel(T viewModel){
    if(_findViewModel<T>(context)!=null){
      throw 'ViewModel already registered in an ancestor state';
    }
    _viewModelIdentifier = ViewModelModule.registerViewModels([viewModel]).first;
  }

  T get viewModel {
    T? viewModel = _findViewModel<T>(context);
    viewModel ??= ViewModelModule.getViewModel<T>(_viewModelIdentifier);
    return viewModel;
  }

  @override
  void dispose() {
    ViewModelModule.destroyViewModels([_viewModelIdentifier]);
    super.dispose();
  }

}

/// Used to register multiple [ViewModel]s in a [State]
/// call [registerViewModels] inside [initState]
mixin MultiViewModelMixin on State{

  late final List<String> _viewModelIdentifiers;

  void registerViewModels(Iterable<ViewModel> viewModels){
    _viewModelIdentifiers = ViewModelModule.registerViewModels(viewModels);
  }

  T getViewModel<T extends ViewModel>() {
    T? viewModel = _findViewModel<T>(context);
    // Checks for ViewModel in current MultiViewModelMixin
    if(viewModel==null) {
      for (String viewModelIdentifier in _viewModelIdentifiers) {
        final vm = ViewModelModule.getViewModel(viewModelIdentifier);
        if (vm is T) {
          viewModel = vm;
        }
      }
    }

    if(viewModel==null) {
      throw 'ViewModel getter called without adding ViewModel first';
    }
    return viewModel;
  }


  @override
  void dispose() {
    ViewModelModule.destroyViewModels(_viewModelIdentifiers);
    super.dispose();
  }
}
