part of 'trip_details_screen.dart';

/// Mobile presentation of Trip Details: a search bar above the scrollable
/// content, with a draggable map sheet floating over the bottom. Data and
/// callbacks come from [TripDetailsScreen].
class TripDetailsMobileView extends StatelessWidget {
  const TripDetailsMobileView({
    super.key,
    required this.vm,
    required this.searchController,
    required this.searchFocus,
    required this.onEditMeta,
    required this.onMapCreated,
    required this.onOpenPlace,
    required this.onMapTap,
    required this.onSearchAdd,
  });

  final TripDetailsViewModel vm;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final VoidCallback onEditMeta;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<String> onOpenPlace;
  final ValueChanged<LatLng> onMapTap;
  final ValueChanged<String> onSearchAdd;

  @override
  Widget build(BuildContext context) {
    final trip = vm.trip;
    return Stack(
      children: [
        Column(
          children: [
            _TopBar(
              controller: searchController,
              focusNode: searchFocus,
              onChanged: vm.queueSearch,
            ),
            Expanded(
              child: trip == null
                  ? const Center(child: CircularProgressIndicator())
                  : _Body(
                      vm: vm,
                      onEditMeta: onEditMeta,
                      onMapCreated: onMapCreated,
                      onMarkerTap: onOpenPlace,
                      onMapTap: onMapTap,
                    ),
            ),
          ],
        ),
        if (vm.searchResults.isNotEmpty)
          Positioned(
            top: 70,
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
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.vm,
    required this.onEditMeta,
    required this.onMapCreated,
    required this.onMarkerTap,
    required this.onMapTap,
  });

  final TripDetailsViewModel vm;
  final VoidCallback onEditMeta;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<String> onMarkerTap;
  final ValueChanged<LatLng> onMapTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final mapCollapsedHeight = maxHeight * 0.15;
        return Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: _tripDetailSlivers(
                  vm: vm,
                  onEditMeta: onEditMeta,
                  bottomPadding: mapCollapsedHeight + 24,
                  onOpenPlace: onMarkerTap,
                ),
              ),
            ),
            _MapSheet(
              vm: vm,
              collapsedHeight: mapCollapsedHeight,
              maxHeight: maxHeight,
              onMapCreated: onMapCreated,
              onMarkerTap: onMarkerTap,
              onMapTap: onMapTap,
            ),
          ],
        );
      },
    );
  }
}

class _MapSheet extends StatefulWidget {
  const _MapSheet({
    required this.vm,
    required this.collapsedHeight,
    required this.maxHeight,
    required this.onMapCreated,
    required this.onMarkerTap,
    required this.onMapTap,
  });

  final TripDetailsViewModel vm;
  final double collapsedHeight;
  final double maxHeight;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<String> onMarkerTap;
  final ValueChanged<LatLng> onMapTap;

  @override
  State<_MapSheet> createState() => _MapSheetState();
}

class _MapSheetState extends State<_MapSheet> {
  bool _expanded = false;
  double? _currentHeight; // non-null only while dragging
  bool _dragging = false;

  static const _sideMargin = 16.0;

  @override
  Widget build(BuildContext context) {
    final collapsed = widget.collapsedHeight;
    final maxHeight = widget.maxHeight;
    final snappedHeight = _expanded ? maxHeight : collapsed;
    final height = _dragging && _currentHeight != null
        ? _currentHeight!
        : snappedHeight;
    final fullScreenFrac = ((height - collapsed) / (maxHeight - collapsed))
        .clamp(0.0, 1.0);
    final margin = _sideMargin * (1 - fullScreenFrac);
    final radius = 24 * (1 - fullScreenFrac);

    return AnimatedPositioned(
      duration: _dragging ? Duration.zero : const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
      bottom: 0,
      left: margin,
      right: margin,
      height: height,
      child: AnimatedContainer(
        duration: _dragging ? Duration.zero : const Duration(milliseconds: 240),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _DragHandle(
              onDragUpdate: (d) {
                setState(() {
                  _dragging = true;
                  final base = _currentHeight ?? snappedHeight;
                  _currentHeight = (base - d.primaryDelta!).clamp(
                    collapsed,
                    maxHeight,
                  );
                });
              },
              onDragEnd: (_) {
                final mid = (collapsed + maxHeight) / 2;
                final h = _currentHeight ?? snappedHeight;
                setState(() {
                  _dragging = false;
                  _expanded = h > mid;
                  _currentHeight = null;
                });
              },
              onTap: () => setState(() => _expanded = !_expanded),
            ),
            Expanded(
              child: _MapView(
                vm: widget.vm,
                onMapCreated: widget.onMapCreated,
                onMarkerTap: widget.onMarkerTap,
                onMapTap: widget.onMapTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
  });

  final ValueChanged<DragUpdateDetails> onDragUpdate;
  final ValueChanged<DragEndDetails> onDragEnd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: onDragUpdate,
      onVerticalDragEnd: onDragEnd,
      onTap: onTap,
      child: SizedBox(
        height: 28,
        child: Center(
          child: Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.label.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}
