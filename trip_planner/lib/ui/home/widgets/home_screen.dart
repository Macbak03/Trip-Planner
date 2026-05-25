import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_planner/ui/home/view_models/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  static const _testCamera = CameraPosition(
    target: LatLng(52.2297, 21.0122),
    zoom: 11,
  );

  static final _testMarkers = <Marker>{
    const Marker(
      markerId: MarkerId('warsaw'),
      position: LatLng(52.2297, 21.0122),
      infoWindow: InfoWindow(title: 'Warsaw'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Column(
              children: [
                const SizedBox(height: 24),
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
                const SizedBox(height: 16),
                const Text(
                  'Google Maps API test',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        initialCameraPosition: _testCamera,
                        markers: _testMarkers,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
