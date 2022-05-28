class ViewModelAlreadyRegistered implements Exception {
  late final String message;
  ViewModelAlreadyRegistered(String viewModelType){
    message = 'ViewModel of type $viewModelType already registered in this route';
  }
}

class ViewModelNotFound implements Exception {
  late final String message;
  ViewModelNotFound(String viewModelType){
    message = 'No ViewModel of type $viewModelType registered in this route';
  }
}