import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/subscription_model.dart';
import '../cubit/subscriptions_cubit.dart';

class EditSubscriptionSheet extends StatefulWidget {
  const EditSubscriptionSheet({super.key, required this.subscription});

  final SubscriptionModel subscription;

  @override
  State<EditSubscriptionSheet> createState() => _EditSubscriptionSheetState();
}

class _EditSubscriptionSheetState extends State<EditSubscriptionSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _priceController;
  late final TextEditingController _currencyController;
  late final TextEditingController _notesController;

  late String _billingCycle;
  late DateTime _firstPaymentDate;
  late bool _isActive;
  bool _isSubmitting = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    final s = widget.subscription;
    _nameController = TextEditingController(text: s.name);
    _categoryController = TextEditingController(text: s.category ?? '');
    _priceController = TextEditingController(
      text: s.price.toStringAsFixed(2),
    );
    _currencyController = TextEditingController(text: s.currency);
    _notesController = TextEditingController(text: s.notes ?? '');
    _billingCycle = s.billingCycle;
    _firstPaymentDate = s.firstPaymentDate;
    _isActive = s.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _currencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _firstPaymentDate,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF22C55E),
              surface: Color(0xFF020617),
              background: Color(0xFF020617),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _firstPaymentDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final name = _nameController.text.trim();
    final priceStr = _priceController.text.trim();
    final currency = _currencyController.text.trim().toUpperCase();
    final category = _categoryController.text.trim();
    final notes = _notesController.text.trim();

    if (name.isEmpty || priceStr.isEmpty || currency.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad, qiymət və valyuta mütləqdir')),
      );
      return;
    }

    final price = double.tryParse(priceStr.replaceAll(',', '.'));
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Qiymət düzgün formatda deyil')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final cubit = context.read<SubscriptionsCubit>();
    await cubit.updateSubscription(
      id: widget.subscription.id,
      name: name,
      category: category.isEmpty ? null : category,
      price: price,
      currency: currency,
      billingCycle: _billingCycle,
      firstPaymentDate: _firstPaymentDate,
      isActive: _isActive,
      notes: notes.isEmpty ? null : notes,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (!mounted) return;

    final state = cubit.state;
    if (state is SubscriptionsFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else {
      Navigator.of(context).pop(); // uğurlu update → sheet bağla
    }
  }

  Future<void> _confirmAndDelete() async {
    if (_isDeleting) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF020617),
          title: const Text(
            'Subscription-u sil',
            style: TextStyle(
              color: Color(0xFFF9FAFB),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Bu abunəliyi həqiqətən silmək istəyirsən? Bu əməliyyatı geri qaytarmaq olmur.',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Ləğv et'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Sil',
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _isDeleting = true;
    });

    final cubit = context.read<SubscriptionsCubit>();
    await cubit.deleteSubscription(widget.subscription.id);

    if (!mounted) return;

    setState(() {
      _isDeleting = false;
    });

    final state = cubit.state;
    if (state is SubscriptionsFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else {
      Navigator.of(context).pop(); // uğurlu silmə → sheet bağla
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF020617);
    const handleColor = Color(0xFF4B5563);
    const titleColor = Color(0xFFF9FAFB);
    const subtitleColor = Color(0xFF9CA3AF);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final s = widget.subscription;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.45,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: bottomInset > 0 ? bottomInset + 16 : 20,
              ),
              decoration: const BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x99000000),
                    blurRadius: 30,
                    spreadRadius: -4,
                    offset: Offset(0, -12),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
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
                    Row(
                      children: [
                        const Text(
                          'Subscription-u redaktə et',
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          s.name,
                          style: const TextStyle(
                            color: subtitleColor,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Qiyməti, statusu və tarixi yenilə.',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18),

                    _DarkLabel(text: 'Ad'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Netflix, Spotify, iCloud...',
                      ),
                    ),
                    const SizedBox(height: 14),

                    _DarkLabel(text: 'Kateqoriya'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        hintText: 'Entertainment, Productivity...',
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DarkLabel(text: 'Qiymət'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _priceController,
                                decoration: const InputDecoration(
                                  hintText: '9.99',
                                ),
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DarkLabel(text: 'Valyuta'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _currencyController,
                                decoration: const InputDecoration(
                                  hintText: 'USD',
                                ),
                                textCapitalization:
                                TextCapitalization.characters,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    _DarkLabel(text: 'Ödəniş dövrü'),
                    const SizedBox(height: 6),
                    _BillingCycleDropdown(
                      value: _billingCycle,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _billingCycle = value);
                      },
                    ),
                    const SizedBox(height: 14),

                    _DarkLabel(text: 'İlk ödəniş tarixi'),
                    const SizedBox(height: 6),
                    _DateField(
                      date: _firstPaymentDate,
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _DarkLabel(text: 'Aktiv olsun'),
                        Switch(
                          value: _isActive,
                          activeColor: const Color(0xFF22C55E),
                          onChanged: (val) {
                            setState(() {
                              _isActive = val;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    _DarkLabel(text: 'Qeyd'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Family plan, 4 nəfər paylaşırıq...',
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        )
                            : const Text('Yenilə'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed:
                            (_isSubmitting || _isDeleting) ? null : _confirmAndDelete,
                        icon: _isDeleting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFEF4444),
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFEF4444),
                              ),
                        label: const Text(
                          'Subscription-u sil',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DarkLabel extends StatelessWidget {
  const _DarkLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _BillingCycleDropdown extends StatelessWidget {
  const _BillingCycleDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      DropdownMenuItem(
        value: 'DAILY',
        child: Text('Gündəlik'),
      ),
      DropdownMenuItem(
        value: 'WEEKLY',
        child: Text('Həftəlik'),
      ),
      DropdownMenuItem(
        value: 'MONTHLY',
        child: Text('Aylıq'),
      ),
      DropdownMenuItem(
        value: 'YEARLY',
        child: Text('İllik'),
      ),
    ];

    return DropdownButtonFormField<String>(
      value: value.toUpperCase(),
      items: items,
      onChanged: onChanged,
      dropdownColor: const Color(0xFF020617),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.date,
    required this.onTap,
  });

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formatted = date.toLocal().toString().split(' ').first;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF020617),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1F2937)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 8),
            Text(
              formatted,
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontSize: 13,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }
}