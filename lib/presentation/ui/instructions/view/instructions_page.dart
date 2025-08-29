import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unsub/presentation/shared/color.dart';
import 'package:unsub/presentation/ui/instructions/provider/instructions_provider.dart';
import 'package:unsub/presentation/ui/instructions/view/instructions_body.dart';
import 'package:unsub/presentation/widgets/text/primary_text.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIColor.transparent,
        surfaceTintColor: UIColor.transparent,
        title: PrimaryText("Instructions", fontSize: 18),
      ),
      body: ChangeNotifierProvider(
        create: (context) => InstructionsProvider(),
        child: InstructionsBody(),
      ),
    );
  }
}
