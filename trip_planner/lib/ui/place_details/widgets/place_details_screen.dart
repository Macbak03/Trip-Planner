import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({
    super.key,
    required this.tripId,
    required this.placeId,
  });

  final String tripId;
  final String placeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.place_outlined, size: 64),
              const SizedBox(height: 16),
              Text('Trip ID: $tripId',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text('Place ID: $placeId',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
