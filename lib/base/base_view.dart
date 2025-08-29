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

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>>  with AutomaticKeepAliveClientMixin<BaseView<T>> {
  late T viewModel;

  @override
  void initState() {
    try {
      viewModel = context.read<T>();
      viewModel.setContext(context);
      viewModel.onInit();
      WidgetsBinding.instance
          .addPostFrameCallback((timeStamp) => viewModel.onReady());
    } catch (e) {
      debugPrint("Error initializing ViewModel: $e");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.build(context, context.watch<T>());
  }

  @override
  void dispose() {
    try {
      viewModel.onClose();
    } catch (e) {
      debugPrint("Error during dispose: $e");
    }
    super.dispose();

  }

  @override
  bool get wantKeepAlive => true;

}
