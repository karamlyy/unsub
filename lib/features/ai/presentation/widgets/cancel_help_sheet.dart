import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/ai_repository.dart';
import '../cubit/cancel_help_cubit.dart';
import '../../../../core/theme/theme_helper.dart';

class CancelHelpSheet extends StatefulWidget {
  const CancelHelpSheet({super.key, required this.subscriptionName});

  final String subscriptionName;

  @override
  State<CancelHelpSheet> createState() => _CancelHelpSheetState();
}

class _CancelHelpSheetState extends State<CancelHelpSheet> {
  @override
  void initState() {
    super.initState();
    // Lazy load olacaq, cubit sonradan context-də hazır olur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CancelHelpCubit>().load(
        subscriptionName: widget.subscriptionName,
        platform: 'general',
        locale: 'az',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = ThemeHelper.sheetBackground(context);
    final titleColor = ThemeHelper.titleColor(context);
    final subtitleColor = ThemeHelper.subtitleColor(context);
    final handleColor = ThemeHelper.handleColor(context);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: ThemeHelper.overlayColor(context),
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: bottomInset > 0 ? bottomInset + 16 : 20,
              ),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeHelper.isDark(context)
                        ? const Color(0x99000000)
                        : const Color(0x33000000),
                    blurRadius: 30,
                    spreadRadius: -4,
                    offset: const Offset(0, -12),
                  ),
                ],
              ),
              child: BlocBuilder<CancelHelpCubit, CancelHelpState>(
                builder: (context, state) {
                  if (state is CancelHelpLoading ||
                      state is CancelHelpInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CancelHelpFailure) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.error_outline,
                          color: Color(0xFFF97373),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AI cavabı alınmadı',
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.message,
                          style: TextStyle(color: subtitleColor, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            context.read<CancelHelpCubit>().load(
                              subscriptionName: widget.subscriptionName,
                              platform: 'general',
                              locale: 'az',
                            );
                          },
                          child: const Text('Yenidən cəhd et'),
                        ),
                      ],
                    );
                  }

                  if (state is! CancelHelpLoaded) {
                    return const SizedBox.shrink();
                  }

                  final text = state.model.instructions;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: handleColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '"${widget.subscriptionName}" ləğv etmə təlimatı',
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'AI sənin üçün addım-addım ləğv etmə bələdçisi hazırladı:',
                        style: TextStyle(color: subtitleColor, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Text(
                            text,
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Sheet yaratmaq üçün helper
Widget buildCancelHelpSheet(BuildContext context, String subscriptionName) {
  final repo = context.read<AiRepository>();
  return BlocProvider(
    create: (_) => CancelHelpCubit(repository: repo),
    child: CancelHelpSheet(subscriptionName: subscriptionName),
  );
}
