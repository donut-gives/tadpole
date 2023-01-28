part of 'context_utils.dart';


/// Used to find [ViewModel] in ancestral [StatefulWidget]
///
/// Example:
/// class Screen extends [StatelessWidget] with [ViewModelMixin]{
///   @override
///   void build(BuildContext context){
///     final viewModel = getViewModel<ScreenViewModel>(context);
///     // use ViewModel
///     return Widget();
///   }
/// }
mixin ViewModelMixin on Widget {
  getViewModel<K extends ViewModel>(BuildContext context, [String? key]){
    if (key != null) {
      K? viewModel = SharedViewModelRepository.requestViewModel<K>(key);
      if (viewModel != null) {
        return viewModel;
      }
    }
    K? viewModel = _findViewModelInAncestor<K>(context);
    if (viewModel == null) {
      throw ViewModelNotFound(K);
    }
    return viewModel;
  }
}