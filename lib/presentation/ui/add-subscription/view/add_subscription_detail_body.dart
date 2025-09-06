import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unsub/data/model/service/services_model.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class AddSubscriptionDetailBody extends StatelessWidget {
  final Service? selectedService;
  
  const AddSubscriptionDetailBody({super.key, this.selectedService});

  @override
  Widget build(BuildContext context) {
    if (selectedService == null) {
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: UIColor.error,
              ),
              16.verticalSpace,
              const PrimaryText(
                "No service selected",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              8.verticalSpace,
              PrimaryText(
                "Please go back and select a service",
                fontSize: 14,
                color: Colors.white60,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            PrimaryText(
              "Selected Service",
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            24.verticalSpace,
            
            // Карточка выбранного сервиса
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: UIColor.textfieldBackground,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: UIColor.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Логотип сервиса
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: UIColor.primary,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        selectedService!.logo ?? '',
                        width: 60.w,
                        height: 60.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 60.w,
                          height: 60.w,
                          color: UIColor.primary.withValues(alpha: 0.1),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.business,
                            size: 32,
                            color: UIColor.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  
                  // Название сервиса
                  PrimaryText(
                    selectedService!.label ?? 'Unknown Service',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                  8.verticalSpace,
                  
                  // ID сервиса
                  PrimaryText(
                    "ID: ${selectedService!.id ?? 'N/A'}",
                    fontSize: 14,
                    color: Colors.white60,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            32.verticalSpace,
            
            // Заголовок для деталей подписки
            PrimaryText(
              "Subscription Details",
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            16.verticalSpace,
            
            // Здесь можно добавить поля для ввода деталей подписки
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: UIColor.textfieldBackground,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    "Configure your subscription",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  12.verticalSpace,
                  PrimaryText(
                    "Add pricing, billing cycle, and other details here...",
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Кнопка для продолжения
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Добавить логику для сохранения деталей подписки
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: UIColor.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const PrimaryText(
                  "Continue",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


