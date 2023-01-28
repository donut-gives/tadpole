import 'package:flutter/widgets.dart';
import 'package:viumodel/src/lifecycle.dart';
import 'package:viumodel/src/live_notifier.dart';

class Observer<L> extends StatefulWidget {
  const Observer({Key? key, this.child, required this.builder, required this.liveNotifier}) : super(key: key);

  final LiveNotifier<L> liveNotifier;
  final Widget Function(BuildContext context, L value, Widget? child) builder;
  final Widget? child;

  @override
  State<Observer> createState() => _ObserverState();
}

class _ObserverState extends State<Observer> with LifeCycleOwnerMixin {
  @override
  void initState() {
    widget.liveNotifier.observe(lifeCycleOwner, () {setState((){});});
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.liveNotifier.value, widget.child);
  }
}
