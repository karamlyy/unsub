import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/text-field/primary_textfield.dart';

class PlatformDateField extends StatelessWidget {
  const PlatformDateField({
    super.key,
    required this.controller,
    required this.onDateSelected,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.hintText = 'First Payment',
    this.suffixIcon = const Icon(CupertinoIcons.calendar, color: UIColor.textPrimary),
  });

  final TextEditingController controller;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  final DateTime? firstDate;
  final DateTime? lastDate;

  final String hintText;
  final Widget? suffixIcon;

  bool get _isCupertino =>
      defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS;

  Future<DateTime?> _pickPlatformDate(BuildContext context) async {
    final initial = selectedDate ?? DateTime.now();
    final min = firstDate ?? DateTime(2000);
    final max = lastDate ?? DateTime(2101);

    if (_isCupertino) {
      DateTime temp = initial;
      await showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return Container(
            height: 320,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Done', style: TextStyle(color: UIColor.primary)),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initial,
                    minimumYear: min.year,
                    maximumYear: max.year,
                    onDateTimeChanged: (d) => temp = d,
                  ),
                ),
              ],
            ),
          );
        },
      );
      return temp;
    } else {
      return await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: min,
        lastDate: max,
        builder: (ctx, child) => child ?? const SizedBox.shrink(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryTextFormField(
      hintText: hintText,
      readOnly: true,
      controller: controller,
      suffixIcon: suffixIcon,
      onTap: () async {
        final picked = await _pickPlatformDate(context);
        if (picked != null) {
          onDateSelected(picked);
        }
      },
    );
  }
}