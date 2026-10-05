import 'package:flutter/material.dart';
import '../../../../core/widgets/pulse_app_bar.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PulseAppBar(title: 'Pulse Live', showBackButton: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Featured Streams', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => context.push('/watch/mock-stream-$index'),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Center(child: Icon(Icons.videocam, size: 48, color: AppColors.outline)),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text('Live Categories', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Gaming', 'Music', 'Creative', 'IRL', 'Chatting'].map((category) {
                  return Chip(
                    label: Text(category),
                    backgroundColor: AppColors.surfaceContainerLow,
                    side: BorderSide(color: AppColors.outlineVariant),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
