part of 'place_details_screen.dart';

/// Web presentation of Place Details: the same single-column layout as mobile
/// (title, hero photo, meta and reviews stacked in one card), just centered and
/// width-capped for wide windows, with a floating "Add" button. Reuses the
/// shared [_PlaceDetailsBody] so web and mobile stay identical.
class PlaceDetailsWebView extends StatelessWidget {
  const PlaceDetailsWebView({
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
          child: MaxWidthCenter(
            maxWidth: 640,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
            child: _OuterCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _PlaceDetailsBody(
                  place: place,
                  vm: vm,
                  reviewsController: reviewsController,
                ),
              ),
            ),
          ),
        ),
        if (vm.canAddToTrip)
          Positioned(
            right: 24,
            bottom: 24,
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
