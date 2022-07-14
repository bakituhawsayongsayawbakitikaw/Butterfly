import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/document_bloc.dart';

class RedoIntent extends Intent {
  final BuildContext context;

  const RedoIntent(this.context);
}

class RedoAction extends Action<RedoIntent> {
  RedoAction();

  @override
  void invoke(RedoIntent intent) {
    final bloc = intent.context.read<DocumentBloc>();
    bloc.redo();
    bloc.load();
    bloc.bake();
  }
}
