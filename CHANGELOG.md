## 0.1.0

* Three Viewmodel APIs in ***ViewModeMixin*** for State<StatefulWidget>. 
  1. ***registerViewModel***(create: ()=>ViewModel()) - instead of passing a viewmodel instance that is created from outside, we pass a function create to tell this API how to create a viewmodel.
  2. ***registerSharedViewModel***(key: someStringConstant, createIfNull: ()=>ViewModel()) - this API shares viewmodel using the key which is a String constant. If the viewmodel associated with key is not already created anywhere in the application, a  new viewmodel is created using the function createIfNull and stored
  3. ***getViewModel***<Type of ViewModel>() - this finds and returns the viewmodel registered in the parent widget.

* For Widgets, that only need the access to the viewmodel registered in the parent, we have ***ViewModelProviderMixin*** for Widget