import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class ServiceTile extends StatelessWidget {
  final String title;
  final String logoUrl;
  final VoidCallback onTap;
  final bool isSelected;

  const ServiceTile({super.key,
    required this.title,
    required this.logoUrl,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? UIColor.primary : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(10.w),
          child: Row(
            children: [
              ClipOval(
                child: Image.network(
                  logoUrl,
                  width: 44.w,
                  height: 44.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 44.w,
                    height: 44.w,
                    color: Colors.white12,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined, size: 18),
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: PrimaryText(
                  title,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? UIColor.primary : Colors.white,
                ),
              ),
              Icon(CupertinoIcons.chevron_forward, size: 18, color: Colors.white60),
            ],
          ),
        ),
      ),
    );
  }
}
