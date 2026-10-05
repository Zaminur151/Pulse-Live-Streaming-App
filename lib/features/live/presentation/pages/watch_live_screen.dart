import 'package:flutter/material.dart';

class WatchLiveScreen extends StatelessWidget {
  final String streamId;
  const WatchLiveScreen({super.key, required this.streamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Watching Stream $streamId'),
      ),
    );
  }
}
