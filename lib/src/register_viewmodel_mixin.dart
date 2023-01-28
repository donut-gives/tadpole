part of 'context_utils.dart';

/// Used to register [ViewModel]/s or shared [ViewModel]/s in a [State]
/// call [register] inside [initState]
mixin RegisterViewModelMixin<T extends StatefulWidget> on State<T> {
  final Set<ViewModel> _viewModels = {};
  final Set<String> _keys = {};

  /// Registers [ViewModel] with the route
  /// It will throw [ViewModelAlreadyRegistered] exception
  /// if the ViewModel is already registered in the route
  void register<K extends ViewModel>({required K Function() factory}){
    RegisterViewModelMixin? state = context.findAncestorStateOfType<RegisterViewModelMixin>();
    K? viewModel = state?.getViewModel<K>();
    if (viewModel != null) {
      throw ViewModelAlreadyRegistered(K);
    }
    _viewModels.add(factory());
  }

  /// Registers [ViewModel] with the route.
  /// If a [ViewModel] is stored with the same key in the application,
  /// this function does not create a new [ViewModel]
  /// but registers the already registered instance with same key.
  /// This way we can share a [ViewModel] across different routes.
  /// It will throw [ViewModelAlreadyRegistered] exception
  /// if the ViewModel is already registered in the route
  void registerShared<K extends ViewModel>({required String key, required K Function() factory}){
    K? viewModel = _findViewModelInAncestor(context);
    if (viewModel != null) {
      throw ViewModelAlreadyRegistered(K);
    }
    viewModel = SharedRepository.claimViewModel(key, factory) as K;
    _viewModels.add(viewModel);
  }


  /// Finds and returns the [ViewModel] from a route.
  /// It will return null if no [ViewModel] is present.
  /// if the [ViewModel] is not registered in the route.
  K? getViewModel<K extends ViewModel>(){
    K? viewModel = _findViewModelInAncestor(context);
    if (viewModel == null) {
      try {
        viewModel =
        _viewModels.firstWhere((element) => element is K) as K;
      } catch (e) {
        return null;
      }
    }
    return viewModel;
  }

  @override
  void dispose() {
    List<ViewModel> vms = List.empty(growable: true);
    for (String key in _keys) {
      ViewModel? vm = SharedRepository.disclaim(key);
      if (vm != null) {
        vms.add(vm);
      }
    }
    for (ViewModel viewModel in _viewModels) {
      if (vms.contains(viewModel)) continue;
      viewModel.destroy();
    }
    super.dispose();
  }
}



