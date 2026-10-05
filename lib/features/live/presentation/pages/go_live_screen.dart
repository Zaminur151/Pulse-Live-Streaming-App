import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/pulse_app_bar.dart';

class GoLiveScreen extends StatelessWidget {
  const GoLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PulseAppBar(title: 'Broadcast Setup'),
      body: Center(
        child: AppButton(
          text: 'Start Live',
          variant: AppButtonVariant.live,
          onPressed: () => context.push('/broadcast'),
        ),
      ),
    );
  }
}
