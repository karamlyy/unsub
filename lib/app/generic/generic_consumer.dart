import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsub/app/generic/generic_state.dart';
import 'package:unsub/presentation/widgets/bottom-sheet/primary_bottom_sheet.dart';
import 'package:unsub/presentation/widgets/indicator/loading_indicator.dart';

class GenericConsumer<B extends StateStreamable<S>, S> extends BlocConsumer<B, S> {
  const GenericConsumer({
    super.key,
    required super.builder,
    required super.listener,
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

  @override
  BlocWidgetListener<S> get listener {
    return (context, state) {
      if (state is Failure) {
        PrimaryBottomSheet.show(
          context,
          text: state.error.message,
        );
      }

      return super.listener(context, state);
    };
  }
}
