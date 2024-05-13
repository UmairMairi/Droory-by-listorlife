import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_view_model.dart';

abstract class BaseView<T extends BaseViewModel> extends StatefulWidget {
  const BaseView({super.key});

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();

  @protected
  Widget build(BuildContext context, T viewModel);
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  late T viewModel;

  @override
  void initState() {
    viewModel = context.read<T>();
    viewModel.setContext(context);
    viewModel.onInit();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => viewModel.onReady());
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, context.watch<T>());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    viewModel.onClose();
    super.dispose();
  }
}
