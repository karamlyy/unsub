import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/subscriptions_cubit.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/services/categories_service.dart';
import '../../../../core/network/api_client.dart';

class AddSubscriptionSheet extends StatefulWidget {
  const AddSubscriptionSheet({super.key});

  @override
  State<AddSubscriptionSheet> createState() => _AddSubscriptionSheetState();
}

class _AddSubscriptionSheetState extends State<AddSubscriptionSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _currencyController;
  late final TextEditingController _notesController;

  String? _selectedCategory;
  String _billingCycle = 'MONTHLY';
  DateTime _firstPaymentDate = DateTime.now();
  bool _isActive = true;
  bool _isSubmitting = false;
  
  List<CategoryModel> _categories = [];
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _currencyController = TextEditingController(text: 'USD');
    _notesController = TextEditingController();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final apiClient = context.read<ApiClient>();
      final categoriesService = CategoriesService(apiClient: apiClient);
      final categories = await categoriesService.getCategories();
      setState(() {
        _categories = categories;
        _loadingCategories = false;
      });
    } catch (e) {
      print('Error loading categories: $e');
      setState(() {
        _loadingCategories = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            colorScheme: ThemeHelper.datePickerColorScheme(context),
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
    final category = _selectedCategory;
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
    await cubit.addSubscription(
      name: name,
      category: category,
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
      Navigator.of(context).pop(); // uğurlu → sheet bağla
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = ThemeHelper.sheetBackground(context);
    final handleColor = ThemeHelper.handleColor(context);
    final titleColor = ThemeHelper.titleColor(context);
    final subtitleColor = ThemeHelper.subtitleColor(context);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: ThemeHelper.overlayColor(context),
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
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
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
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // drag handle
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
                      'Yeni subscription',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ayda nəyə nə qədər gedir, qaranlıqda qalmasın.',
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

                    _DarkLabel(text: 'Kateqoriya (optional)'),
                    const SizedBox(height: 6),
                    _loadingCategories
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : _CategoryDropdown(
                            categories: _categories,
                            value: _selectedCategory,
                            onChanged: (value) {
                              setState(() => _selectedCategory = value);
                            },
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
                                    decimal: true),
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
                                textCapitalization: TextCapitalization.characters,
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
                          activeTrackColor: const Color(0xFF22C55E),
                          onChanged: (val) {
                            setState(() {
                              _isActive = val;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _DarkLabel(text: 'Qeyd (optional)'),
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
                            AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                            : const Text('Əlavə et'),
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
      style: TextStyle(
        color: ThemeHelper.subtitleColor(context),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categories,
    required this.value,
    required this.onChanged,
  });

  final List<CategoryModel> categories;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = categories
        .map((category) => DropdownMenuItem<String>(
              value: category.name,
              child: Text(category.name),
            ))
        .toList();

    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: ThemeHelper.dropdownColor(context),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        hintText: categories.isEmpty ? 'Kateqoriya yoxdur' : 'Kateqoriya seç',
        hintStyle: TextStyle(
          color: ThemeHelper.subtitleColor(context).withOpacity(0.6),
        ),
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
      value: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: ThemeHelper.dropdownColor(context),
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
    final fillColor = ThemeHelper.inputFillColor(context);
    final borderColor = ThemeHelper.borderColor(context);
    final iconColor = ThemeHelper.subtitleColor(context);
    final textColor = ThemeHelper.titleColor(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: iconColor,
            ),
            const SizedBox(width: 8),
            Text(
              formatted,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}