import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderConsumer<T> extends StatefulWidget {
  final Function(T value)? onChange;
  final ValueNotifier<T> controller;
  final Widget Function(ValueNotifier<T> controller) builder;

  const ProviderConsumer({Key? key, required this.controller, required this.builder, this.onChange})
      : super(key: key);

  @override
  _ProviderConsumerState<T> createState() => _ProviderConsumerState<T>();
}

class _ProviderConsumerState<T> extends State<ProviderConsumer<T>> {

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
  }

  _onControllerChange() {
    if (widget.onChange != null) {
      widget.onChange!(widget.controller.value);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_onControllerChange);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: widget.controller,
        child: Consumer<ValueNotifier<T>>(
            builder: (_, ValueNotifier<T> belonging, __) =>
                widget.builder(belonging)));
  }
}
