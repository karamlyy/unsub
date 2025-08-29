import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsub/app/generic/generic_state.dart';
import 'package:unsub/presentation/widgets/indicator/loading_indicator.dart';

class GenericBuilder<B extends StateStreamable<S>, S> extends BlocBuilder<B, S> {
  const GenericBuilder({
    super.key,
    required super.builder,
  });

  @override
  BlocWidgetBuilder<S> get builder {
    return (context, state) {
      if (state is InProgress) {
        return const Center(child: LoadingIndicator());
      }
      return super.builder(context, state);
    };
  }
}
