import 'package:flutter/material.dart';
import 'package:trip_planner/ui/home/view_models/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(viewModel.email ?? ''),
                const SizedBox(height: 16),
                ListenableBuilder(
                  listenable: viewModel.logout,
                  builder: (context, _) {
                    return ElevatedButton(
                      onPressed: viewModel.logout.running
                          ? null
                          : () => viewModel.logout.execute(),
                      child: viewModel.logout.running
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign out'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
