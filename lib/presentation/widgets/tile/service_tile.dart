import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class ServiceTile extends StatelessWidget {
  final String title;
  final String logoUrl;
  final VoidCallback onTap;

  const ServiceTile({
    required this.title,
    required this.logoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white10),
        ),
        child: Padding(
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