import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_button.dart';

class LiveBroadcastScreen extends StatelessWidget {
  const LiveBroadcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Live Broadcasting...'),
            const SizedBox(height: 16),
            AppButton(
              text: 'End Stream',
              variant: AppButtonVariant.live,
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}
