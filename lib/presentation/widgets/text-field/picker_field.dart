import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/text-field/primary_textfield.dart';

class PlatformPickerField<T> extends StatelessWidget {
  const PlatformPickerField({
    super.key,
    required this.items,
    required this.onSelected,
    required this.displayStringFor,
    this.current,
    this.titleText = 'Select an option',
    this.hintText,
    this.enabled = true,
    this.suffixIcon = const Icon(Icons.keyboard_arrow_down_rounded, color: UIColor.textPrimary),
    this.itemLeadingBuilder,
    this.itemTrailingBuilder,
    this.equality,
  });

  final List<T> items;

  final T? current;

  final String Function(T value) displayStringFor;

  final ValueChanged<T> onSelected;

  final String titleText;

  final String? hintText;

  final bool enabled;

  final Widget? suffixIcon;

  final Widget? Function(BuildContext context, T value)? itemLeadingBuilder;
  final Widget? Function(BuildContext context, T value)? itemTrailingBuilder;

  final bool Function(T a, T b)? equality;

  bool get _isCupertino => defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;

  bool _isEqual(T a, T b) => (equality != null) ? equality!(a, b) : a == b;

  Future<void> _showPicker(BuildContext context) async {
    if (!enabled || items.isEmpty) return;

    if (_isCupertino) {
      await showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          title: Text(titleText),
          actions: items.map((e) {
            final leading = itemLeadingBuilder?.call(ctx, e);
            final trailing = itemTrailingBuilder?.call(ctx, e);
            final text = displayStringFor(e);

            return CupertinoActionSheetAction(
              onPressed: () {
                onSelected(e);
                Navigator.of(ctx).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[leading, const SizedBox(width: 8)],
                  Flexible(child: Text(text, textAlign: TextAlign.center)),
                  if (trailing != null) ...[const SizedBox(width: 8), trailing],
                ],
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(ctx).pop(),
            isDefaultAction: true,
            child: const Text('Cancel'),
          ),
        ),
      );
    } else {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.surface,
        showDragHandle: true,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  titleText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ...items.map((e) {
                final isSelected = (current != null) && _isEqual(current as T, e);
                final leading = itemLeadingBuilder?.call(ctx, e);
                final trailing = itemTrailingBuilder?.call(ctx, e) ??
                    (isSelected ? const Icon(Icons.check_rounded) : null);

                return ListTile(
                  leading: leading,
                  title: Text(displayStringFor(e)),
                  trailing: trailing,
                  onTap: () {
                    onSelected(e);
                    Navigator.of(ctx).pop();
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = current != null
        ? displayStringFor(current as T)
        : (hintText ?? 'Select');

    return AbsorbPointer(
      absorbing: !enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.6,
        child: PrimaryTextFormField(
          hintText: text,
          readOnly: true,
          onTap: () => _showPicker(context),
          keyboardType: TextInputType.text,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}