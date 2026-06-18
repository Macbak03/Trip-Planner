part of 'place_details_screen.dart';

/// Mobile presentation of Place Details: a single scrollable card (title, hero
/// photo, meta, reviews) with a floating "Add" FAB in the bottom-right. Reuses
/// the shared components from [PlaceDetailsScreen].
class PlaceDetailsMobileView extends StatelessWidget {
  const PlaceDetailsMobileView({
    super.key,
    required this.place,
    required this.vm,
    required this.reviewsController,
    required this.onAdd,
    required this.onRemove,
  });

  final Place place;
  final PlaceDetailsViewModel vm;
  final LoopPageController reviewsController;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: _OuterCard(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: _PlaceDetailsBody(
                place: place,
                vm: vm,
                reviewsController: reviewsController,
              ),
            ),
          ),
        ),
        if (vm.canAddToTrip)
          Positioned(
            right: 20,
            bottom: 20,
            child: vm.isInCurrentDay
                ? _AddFab(
                    onTap: onRemove,
                    running: vm.removeFromTrip.running,
                    isRemove: true,
                  )
                : _AddFab(onTap: onAdd, running: vm.addToTrip.running),
          ),
      ],
    );
  }
}
