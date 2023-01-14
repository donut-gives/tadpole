import 'viewmodel_exceptions.dart';
import 'viewmodel.dart';
import 'package:flutter/widgets.dart';

T? _findViewModel<T extends ViewModel>(BuildContext context) {
  T? viewModel;
  // Checks for ViewModel in ancestral ViewModelMixins
  ViewModelRegisterMixin? viewModelMixin = context.findAncestorStateOfType<ViewModelRegisterMixin>();
  viewModel = viewModelMixin?.getViewModelOrNull<T>();
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
  final _cache = {};

  T getViewModel<T extends ViewModel>(BuildContext context) {
    if (_cache[T.toString()]) {
      T? viewModel = _findViewModel<T>(context);
      if (viewModel == null) {
        throw ViewModelNotFound(T.toString());
      }
      _cache.addAll({T.toString(): viewModel});
      return viewModel;
    } else {
      return _cache[T.toString()];
    }
  }
}


/// Used to register [ViewModel]/s or shared [ViewModel]/s in a [State]
/// call [registerViewModel] inside [initState]
mixin ViewModelRegisterMixin<K extends StatefulWidget> on State<K> {
  late final List<String> _viewModelIdentifiers = [];
  late final Map<String, String> _sharedViewModelKeysAndIdentifiers = {};


  /// Registers [ViewModel] with the route
  /// It will throw [ViewModelAlreadyRegistered] exception
  /// if the ViewModel is already registered in the route
  void registerViewModel<T extends ViewModel>({required T Function() create}){
    if(_findViewModel<T>(context)!=null){
      throw ViewModelAlreadyRegistered(T.toString());
    }
    T viewModel = create();
    String id = ViewModelModule.registerViewModel(viewModel);
    _viewModelIdentifiers.add(id);
  }

  /// Registers [ViewModel] with the route.
  /// If a [ViewModel] with same key is present in the application,
  /// this function does not create the [ViewModel]
  /// but registers the already registered instance with same key.
  /// This way we can share a [ViewModel] across different routes.
  /// It will throw [ViewModelAlreadyRegistered] exception
  /// if the ViewModel is already registered in the route
  void registerSharedViewModel<T extends ViewModel>({required String key, required T Function() createIfNull}){
    if(_findViewModel<T>(context)!=null){
      throw ViewModelAlreadyRegistered(T.toString());
    }
    T? viewModel = ViewModelModule.getViewModelFromKey<T>(key);
    viewModel ??= createIfNull();
    String id = ViewModelModule.registerViewModel(viewModel, key);
    _viewModelIdentifiers.add(id);
    _sharedViewModelKeysAndIdentifiers.addAll({key: id});
  }

  /// Finds and returns the [ViewModel] from a route.
  /// It will return null if no [ViewModel] is present.
  /// if the [ViewModel] is not registered in the route.
  T? getViewModelOrNull<T extends ViewModel>(){
    T? viewModel = _findViewModel<T>(context);
    if(viewModel==null) {
      for (String viewModelIdentifier in _viewModelIdentifiers) {
        final vm = ViewModelModule.getViewModel(viewModelIdentifier);
        if (vm is T) {
          viewModel = vm;
        }
      }
    }
    return viewModel;
  }

  /// Finds and returns the [ViewModel] from a route.
  /// It will throw [ViewModelNotFound] exception
  /// if the [ViewModel] is not registered in the route.
  T getViewModel<T extends ViewModel>() {
    T? viewModel = getViewModelOrNull();
    if(viewModel==null){
      throw ViewModelNotFound('$T');
    }
    return viewModel;
  }

  @override
  void dispose() {
    ViewModelModule.destroyViewModels(_viewModelIdentifiers, _sharedViewModelKeysAndIdentifiers);
    _viewModelIdentifiers.clear();
    super.dispose();
  }

}
