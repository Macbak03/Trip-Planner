part of 'trip_details_screen.dart';

/// Web presentation of Trip Details: a two-pane layout — a width-bounded left
/// column with the search bar and the same scrollable content as mobile, plus a
/// persistent map pane on the right (instead of the mobile draggable sheet).
/// Reuses [_tripDetailSlivers], [_MapView], [_TopBar] and
/// [_SearchResultsOverlay]. Data and callbacks come from [TripDetailsScreen].
class TripDetailsWebView extends StatelessWidget {
  const TripDetailsWebView({
    super.key,
    required this.vm,
    required this.searchController,
    required this.searchFocus,
    required this.onEditMeta,
    required this.onMapCreated,
    required this.onOpenPlace,
    required this.onMapTap,
    required this.onSearchAdd,
    required this.inlinePlaceId,
    required this.onCloseInline,
  });

  final TripDetailsViewModel vm;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final VoidCallback onEditMeta;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<String> onOpenPlace;
  final ValueChanged<LatLng> onMapTap;
  final ValueChanged<String> onSearchAdd;

  /// When non-null, a Place Details panel is shown inline over the left edge of
  /// the map pane for this place. [onCloseInline] dismisses it.
  final String? inlinePlaceId;
  final VoidCallback onCloseInline;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final leftWidth = (constraints.maxWidth * 0.42)
            .clamp(380.0, 560.0)
            .toDouble();
        final trip = vm.trip;
        final left = Column(
          children: [
            _TopBar(
              controller: searchController,
              focusNode: searchFocus,
              onChanged: vm.queueSearch,
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: trip == null
                        ? const Center(child: CircularProgressIndicator())
                        : CustomScrollView(
                            physics: const ClampingScrollPhysics(),
                            slivers: _tripDetailSlivers(
                              vm: vm,
                              onEditMeta: onEditMeta,
                              bottomPadding: 24,
                              onOpenPlace: onOpenPlace,
                            ),
                          ),
                  ),
                  if (vm.searchResults.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 16,
                      right: 16,
                      child: _SearchResultsOverlay(
                        results: vm.searchResults,
                        vm: vm,
                        onAdd: onSearchAdd,
                        onTap: onOpenPlace,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
        final map = Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _MapView(
              vm: vm,
              onMapCreated: onMapCreated,
              onMarkerTap: onOpenPlace,
              onMapTap: onMapTap,
            ),
          ),
        );
        final mapPane = Stack(
          children: [
            Positioned.fill(child: map),
            if (inlinePlaceId != null)
              Positioned(
                left: 0,
                top: 8,
                bottom: 16,
                width: 400,
                // Intercept pointer events so taps on the panel (incl. the
                // close button) don't pass through to the Google Map platform
                // view underneath and register as a map tap.
                child: PointerInterceptor(
                  child: PlaceDetailsInlinePanel(
                    key: ValueKey(inlinePlaceId),
                    placeId: inlinePlaceId!,
                    tripId: vm.tripId,
                    dayIndex: vm.selectedDay,
                    onClose: onCloseInline,
                  ),
                ),
              ),
          ],
        );
        return Row(
          children: [
            SizedBox(width: leftWidth, child: left),
            Expanded(child: mapPane),
          ],
        );
      },
    );
  }
}
