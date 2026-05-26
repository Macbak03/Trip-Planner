import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/config/app_theme.dart';
import 'package:trip_planner/domain/models/place/place.dart';
import 'package:trip_planner/domain/models/trip/trip.dart';
import 'package:trip_planner/domain/models/trip/trip_place.dart';
import 'package:trip_planner/routing/routes.dart';
import 'package:trip_planner/ui/trip_details/view_models/trip_details_viewmodel.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key, required this.viewModel});

  final TripDetailsViewModel viewModel;

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late final TextEditingController _searchController;
  final FocusNode _searchFocus = FocusNode();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    widget.viewModel.addListener(_onVmChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onVmChanged);
    widget.viewModel.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onVmChanged() {
    _refreshCameraToMarkers();
  }

  void _refreshCameraToMarkers() {
    final controller = _mapController;
    if (controller == null) return;
    final places = widget.viewModel.placesForSelectedDay;
    final points = <LatLng>[
      for (final p in places)
        if (p.location != null)
          LatLng(p.location!.latitude, p.location!.longitude),
    ];
    if (points.isEmpty) {
      final dest = widget.viewModel.destinationCoords;
      if (dest != null) {
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(dest.latitude, dest.longitude),
            11,
          ),
        );
      }
      return;
    }
    if (points.length == 1) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(points.first, 14),
      );
      return;
    }
    final bounds = _boundsFor(points);
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 48));
  }

  LatLngBounds _boundsFor(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _openEditSheet() async {
    final vm = widget.viewModel;
    final trip = vm.trip;
    if (trip == null) return;
    final update = await showModalBottomSheet<TripMetaUpdate>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _EditTripMetaSheet(trip: trip),
    );
    if (update != null) {
      vm.updateTripMeta.execute(update);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            final trip = vm.trip;
            return Stack(
              children: [
                Column(
                  children: [
                    _TopBar(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      onChanged: vm.queueSearch,
                    ),
                    Expanded(
                      child: trip == null
                          ? const Center(child: CircularProgressIndicator())
                          : _Body(
                              vm: vm,
                              onEditMeta: _openEditSheet,
                              onMapCreated: (c) {
                                _mapController = c;
                                _refreshCameraToMarkers();
                              },
                              onMarkerTap: (placeId) => context.push(
                                Routes.placeDetailsPath(vm.tripId, placeId),
                              ),
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
                      onAdd: (placeId) {
                        vm.addPlace.execute(placeId);
                        _searchController.clear();
                        vm.clearSearch();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onTap: (placeId) {
                        final tripId = vm.tripId;
                        context.push(
                          Routes.placeDetailsPath(tripId, placeId),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.fillsSecondary,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20, color: AppColors.label),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                cursorColor: AppColors.accent,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Find a place...',
                  hintStyle: TextStyle(
                    color: AppColors.labelSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultsOverlay extends StatelessWidget {
  const _SearchResultsOverlay({
    required this.results,
    required this.vm,
    required this.onAdd,
    required this.onTap,
  });

  final List<Place> results;
  final TripDetailsViewModel vm;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(18),
      shadowColor: Colors.black.withValues(alpha: 0.18),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 360),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: results.length,
          separatorBuilder: (_, _) =>
              const Divider(height: 1, color: AppColors.separator),
          itemBuilder: (context, i) {
            final place = results[i];
            return _SearchResultRow(
              place: place,
              photoUrl: place.photoRefs.isEmpty
                  ? null
                  : vm.photoUrl(place.photoRefs.first, maxWidthPx: 160),
              onTap: () => onTap(place.id),
              onAdd: () => onAdd(place.id),
            );
          },
        ),
      ),
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({
    required this.place,
    required this.photoUrl,
    required this.onTap,
    required this.onAdd,
  });

  final Place place;
  final String? photoUrl;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: _PlacePhoto(url: photoUrl),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          place.displayName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _StarRating(
                    rating: place.rating,
                    totalRatings: place.userRatingsTotal,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _AddButton(onTap: onAdd),
          ],
        ),
      ),
    );
  }
}

class _PlacePhoto extends StatelessWidget {
  const _PlacePhoto({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        color: AppColors.separator,
        child: const Icon(
          Icons.image_outlined,
          size: 20,
          color: AppColors.label,
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      placeholder: (_, _) => const ColoredBox(color: AppColors.separator),
      errorWidget: (_, _, _) => Container(
        color: AppColors.separator,
        child: const Icon(
          Icons.image_outlined,
          size: 20,
          color: AppColors.label,
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating, this.totalRatings});

  final double? rating;
  final int? totalRatings;

  @override
  Widget build(BuildContext context) {
    if (rating == null) {
      return const Text(
        'No reviews yet',
        style: TextStyle(fontSize: 12, color: AppColors.label),
      );
    }
    final filled = rating!.round().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < filled ? Icons.star_rounded : Icons.star_border_rounded,
            size: 16,
            color: AppColors.accent,
          ),
        const SizedBox(width: 6),
        Text(
          rating!.toStringAsFixed(1) +
              (totalRatings != null ? ' ($totalRatings)' : ''),
          style: const TextStyle(fontSize: 12, color: AppColors.label),
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Add',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.vm,
    required this.onEditMeta,
    required this.onMapCreated,
    required this.onMarkerTap,
  });

  final TripDetailsViewModel vm;
  final VoidCallback onEditMeta;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<String> onMarkerTap;

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
                slivers: [
                  SliverMainAxisGroup(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                        sliver: SliverToBoxAdapter(
                          child: _CardPiece(
                            topRounded: true,
                            child: _TripMetaCard(
                              trip: vm.trip!,
                              onEdit: onEditMeta,
                            ),
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _StickyDelegate(
                          backgroundColor: AppColors.cardBackground,
                          horizontalPadding: 16,
                          child: _DayTabs(
                            dayCount: vm.dayCount,
                            selectedDay: vm.selectedDay,
                            onSelect: vm.selectDay,
                          ),
                          height: 60,
                        ),
                      ),
                      _DayPlacesSliver(vm: vm),
                    ],
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyDelegate(
                      backgroundColor: AppColors.sheetBackground,
                      child: const _SectionHeader(
                        title: 'Suggested places to visit',
                      ),
                      height: 44,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      4,
                      16,
                      mapCollapsedHeight + 24,
                    ),
                    sliver: _SuggestedPlacesSliver(vm: vm),
                  ),
                ],
              ),
            ),
            _MapSheet(
              vm: vm,
              collapsedHeight: mapCollapsedHeight,
              maxHeight: maxHeight,
              onMapCreated: onMapCreated,
              onMarkerTap: onMarkerTap,
            ),
          ],
        );
      },
    );
  }
}

class _CardPiece extends StatelessWidget {
  const _CardPiece({
    required this.child,
    this.topRounded = false,
    this.bottomRounded = false,
  });

  final Widget child;
  final bool topRounded;
  final bool bottomRounded;

  @override
  Widget build(BuildContext context) {
    final radius = const Radius.circular(20);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: topRounded ? radius : Radius.zero,
          topRight: topRounded ? radius : Radius.zero,
          bottomLeft: bottomRounded ? radius : Radius.zero,
          bottomRight: bottomRounded ? radius : Radius.zero,
        ),
      ),
      child: child,
    );
  }
}

class _StickyDelegate extends SliverPersistentHeaderDelegate {
  _StickyDelegate({
    required this.child,
    required this.height,
    required this.backgroundColor,
    this.horizontalPadding = 0,
  });

  final Widget child;
  final double height;
  final Color backgroundColor;
  final double horizontalPadding;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        color: backgroundColor,
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyDelegate oldDelegate) =>
      oldDelegate.child != child ||
      oldDelegate.height != height ||
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.horizontalPadding != horizontalPadding;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TripMetaCard extends StatelessWidget {
  const _TripMetaCard({required this.trip, required this.onEdit});

  final Trip trip;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        '${DateFormat('MMM d, yyyy').format(trip.startDate)} - '
        '${DateFormat('MMM d, yyyy').format(trip.endDate)}';
    final budgetLabel = '${trip.budget.toStringAsFixed(0)} ${trip.currency}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetaPill(icon: Icons.place_outlined, label: trip.destination),
                _MetaPill(icon: Icons.attach_money, label: budgetLabel),
                _MetaPill(
                  icon: Icons.calendar_today_outlined,
                  label: dateLabel,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onEdit,
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.edit_outlined,
                color: AppColors.accent,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayTabs extends StatelessWidget {
  const _DayTabs({
    required this.dayCount,
    required this.selectedDay,
    required this.onSelect,
  });

  final int dayCount;
  final int selectedDay;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.fillsSecondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            for (var i = 1; i <= dayCount; i++)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelect(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: i == selectedDay
                          ? AppColors.accent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      'Day $i',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: i == selectedDay
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DayPlacesSliver extends StatelessWidget {
  const _DayPlacesSliver({required this.vm});

  final TripDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    final places = vm.placesForSelectedDay;
    if (places.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        sliver: SliverToBoxAdapter(
          child: _CardPiece(
            bottomRounded: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Center(
                child: Text(
                  'No places yet - search or pick from suggestions below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.label.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    final itemCount = places.length * 2;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      sliver: SliverList.builder(
        itemCount: itemCount,
        itemBuilder: (context, i) {
          final isLast = i == itemCount - 1;
          if (i.isOdd) {
            if (isLast) {
              return _CardPiece(
                bottomRounded: true,
                child: const SizedBox(height: 12),
              );
            }
            final dist = places[(i + 1) ~/ 2].distanceFromPrevKm;
            return _CardPiece(child: _DistanceRow(km: dist));
          }
          final idx = i ~/ 2;
          final place = places[idx];
          return _DayPlaceRow(
            place: place,
            onTap: () => context.push(
              Routes.placeDetailsPath(vm.tripId, place.placeId),
            ),
            onRemove: () => vm.removePlace.execute(place.id),
          );
        },
      ),
    );
  }
}

class _DayPlaceRow extends StatelessWidget {
  const _DayPlaceRow({
    required this.place,
    required this.onTap,
    required this.onRemove,
  });

  final TripPlace place;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('trip-place-${place.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red.shade400,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: _CardPiece(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
            child: Row(
              children: [
                const Icon(
                  Icons.place_outlined,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    place.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.label,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DistanceRow extends StatelessWidget {
  const _DistanceRow({required this.km});

  final double? km;

  @override
  Widget build(BuildContext context) {
    final label = km == null
        ? '—'
        : km! < 1
              ? '${(km! * 1000).toStringAsFixed(0)}m'
              : '${km!.toStringAsFixed(2)}km';
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        children: [
          Container(
            width: 1,
            height: 16,
            color: AppColors.label.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: AppColors.label.withValues(alpha: 0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestedPlacesSliver extends StatelessWidget {
  const _SuggestedPlacesSliver({required this.vm});

  final TripDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    final places = vm.suggestedPlaces;
    if (places.isEmpty && vm.loadSuggestedPlaces.running) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (places.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              'No suggestions available',
              style: TextStyle(color: AppColors.label, fontSize: 13),
            ),
          ),
        ),
      );
    }
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final place = places[index];
          return _SuggestedPlaceCard(
            place: place,
            photoUrl: place.photoRefs.isEmpty
                ? null
                : vm.photoUrl(place.photoRefs.first, maxWidthPx: 400),
            onTap: () => context.push(
              Routes.placeDetailsPath(vm.tripId, place.id),
            ),
            onAdd: () => vm.addPlace.execute(place.id),
          );
        },
        childCount: places.length,
      ),
    );
  }
}

class _SuggestedPlaceCard extends StatelessWidget {
  const _SuggestedPlaceCard({
    required this.place,
    required this.photoUrl,
    required this.onTap,
    required this.onAdd,
  });

  final Place place;
  final String? photoUrl;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _PlacePhoto(url: photoUrl),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: _AddButton(onTap: onAdd),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
              child: Text(
                place.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: _StarRating(
                rating: place.rating,
                totalRatings: place.userRatingsTotal,
              ),
            ),
          ],
        ),
      ),
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
  });

  final TripDetailsViewModel vm;
  final double collapsedHeight;
  final double maxHeight;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<String> onMarkerTap;

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
    final height =
        _dragging && _currentHeight != null ? _currentHeight! : snappedHeight;
    final fullScreenFrac =
        ((height - collapsed) / (maxHeight - collapsed)).clamp(0.0, 1.0);
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
                  _currentHeight =
                      (base - d.primaryDelta!).clamp(collapsed, maxHeight);
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

class _MapView extends StatelessWidget {
  const _MapView({
    required this.vm,
    required this.onMapCreated,
    required this.onMarkerTap,
  });

  final TripDetailsViewModel vm;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<String> onMarkerTap;

  @override
  Widget build(BuildContext context) {
    final places = vm.placesForSelectedDay;
    final markers = <Marker>{
      for (final p in places)
        if (p.location != null)
          Marker(
            markerId: MarkerId(p.id),
            position: LatLng(p.location!.latitude, p.location!.longitude),
            infoWindow: InfoWindow(title: p.displayName),
            consumeTapEvents: true,
            onTap: () => onMarkerTap(p.placeId),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
          ),
    };
    final polylinePoints = <LatLng>[
      for (final p in places)
        if (p.location != null)
          LatLng(p.location!.latitude, p.location!.longitude),
    ];
    final polylines = polylinePoints.length < 2
        ? <Polyline>{}
        : <Polyline>{
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylinePoints,
              color: AppColors.accent,
              width: 4,
            ),
          };
    final destCoords = vm.destinationCoords;
    final initialTarget = polylinePoints.isNotEmpty
        ? polylinePoints.first
        : (destCoords != null
              ? LatLng(destCoords.latitude, destCoords.longitude)
              : const LatLng(0, 0));
    final initialZoom = polylinePoints.isNotEmpty
        ? 12.0
        : (destCoords != null ? 11.0 : 2.0);
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: initialTarget,
        zoom: initialZoom,
      ),
      markers: markers,
      polylines: polylines,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
    );
  }
}

class _EditTripMetaSheet extends StatefulWidget {
  const _EditTripMetaSheet({required this.trip});

  final Trip trip;

  @override
  State<_EditTripMetaSheet> createState() => _EditTripMetaSheetState();
}

class _EditTripMetaSheetState extends State<_EditTripMetaSheet> {
  late final TextEditingController _destination;
  late final TextEditingController _budget;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _destination = TextEditingController(text: widget.trip.destination);
    _budget = TextEditingController(
      text: widget.trip.budget.toStringAsFixed(0),
    );
    _startDate = widget.trip.startDate;
    _endDate = widget.trip.endDate;
  }

  @override
  void dispose() {
    _destination.dispose();
    _budget.dispose();
    super.dispose();
  }

  Future<void> _pickDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        '${DateFormat('MMM d, yyyy').format(_startDate)} – '
        '${DateFormat('MMM d, yyyy').format(_endDate)}';
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.label.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Edit trip',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _SheetField(
                icon: Icons.place_outlined,
                controller: _destination,
                hint: 'Destination',
              ),
              const SizedBox(height: 10),
              _SheetField(
                icon: Icons.attach_money,
                controller: _budget,
                hint: 'Budget',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickDates,
                child: _SheetField(
                  icon: Icons.calendar_today_outlined,
                  hint: 'Dates',
                  readOnly: true,
                  text: dateLabel,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        final dest = _destination.text.trim();
                        final budget = double.tryParse(
                          _budget.text.replaceAll(',', '.'),
                        );
                        Navigator.pop(
                          context,
                          TripMetaUpdate(
                            destination: dest.isEmpty ? null : dest,
                            destinationPlaceId:
                                dest != widget.trip.destination ? '' : null,
                            budget: budget,
                            startDate: _startDate,
                            endDate: _endDate,
                          ),
                        );
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.icon,
    required this.hint,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.text,
  });

  final IconData icon;
  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.sheetBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.label),
          const SizedBox(width: 10),
          Expanded(
            child: readOnly && controller == null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      text ?? hint,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  )
                : TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: const TextStyle(color: AppColors.label),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// `Factory` from `dart:ui` is re-exported via material's `Factory`. We use it
// for the map's gestureRecognizers — empty here because gestures are owned by
// the DraggableScrollableSheet and the parent scroll view.
