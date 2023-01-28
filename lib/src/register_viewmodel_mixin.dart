part of 'context_utils.dart';

/// Used to register [ViewModel]/s or shared [ViewModel]/s in a [State]
/// call [register] inside [initState]
mixin RegisterViewModelMixin<T extends StatefulWidget> on State<T> {
  final Set<ViewModel> _viewModels = {};

  /// Registers [ViewModel] with the route
  /// It will throw [ViewModelAlreadyRegistered] exception
  /// if the ViewModel is already registered in the route
  void register<K extends ViewModel>({required K Function() factory}){
    RegisterViewModelMixin? state = context.findAncestorStateOfType<RegisterViewModelMixin>();
    K? viewModel = state?.getViewModel<K>();
    if (viewModel != null) {
      throw ViewModelAlreadyRegistered(K);
    }
    _viewModels.add(factory()..init());
  }


  /// Finds and returns the [ViewModel] from a route.
  /// It will return null if no [ViewModel] is present.
  /// if the [ViewModel] is not registered in the route.
  K getViewModel<K extends ViewModel>([String? key]){
    if (key != null) {
      K? viewModel = SharedViewModelRepository.requestViewModel<K>(key);
      if (viewModel != null) {
        return viewModel;
      }
    }
    K? viewModel = _findViewModelInAncestor(context);
    if (viewModel == null) {
      try {
        viewModel =
        _viewModels.firstWhere((element) => element is K) as K;
      } catch (e) {
        throw ViewModelNotFound(K);
      }
    }
    return viewModel;
  }

  @override
  void dispose() {
    for (ViewModel viewModel in _viewModels) {
      viewModel.destroy();
    }
    super.dispose();
  }
}



