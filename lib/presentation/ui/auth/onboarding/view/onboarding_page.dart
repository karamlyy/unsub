import 'package:flutter/material.dart';
import 'package:unsub/presentation/ui/auth/onboarding/view/onboarding_body.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingBody(),
    );
  }
}
