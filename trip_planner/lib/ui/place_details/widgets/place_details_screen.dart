import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:loop_page_view/loop_page_view.dart';
import 'package:trip_planner/config/app_theme.dart';
import 'package:trip_planner/domain/models/place/place.dart';
import 'package:trip_planner/domain/models/place/place_review.dart';
import 'package:trip_planner/ui/core/widgets/skeleton.dart';
import 'package:trip_planner/ui/place_details/view_models/place_details_viewmodel.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key, required this.viewModel});

  final PlaceDetailsViewModel viewModel;

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  late final LoopPageController _reviewsController;

  @override
  void initState() {
    super.initState();
    _reviewsController = LoopPageController();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    _reviewsController.dispose();
    super.dispose();
  }

  /// Adds the place to the current trip's selected day and returns to the
  /// Trip Details screen. The add runs in the background; Trip Details streams
  /// the places sub-collection, so the new place appears there automatically.
  void _onAddPressed() {
    widget.viewModel.addToTrip.execute();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([vm, vm.load]),
          builder: (context, _) {
            if (vm.load.running && vm.place == null) {
              return const _LoadingBody();
            }
            if (vm.load.error && vm.place == null) {
              return _ErrorBody(onRetry: () => vm.load.execute());
            }
            final place = vm.place;
            if (place == null) return const _LoadingBody();
            return Stack(
              children: [
                _Content(
                  place: place,
                  vm: vm,
                  reviewsController: _reviewsController,
                ),
                if (vm.canAddToTrip)
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: _AddFab(
                      onTap: _onAddPressed,
                      running: vm.addToTrip.running,
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

class _Content extends StatelessWidget {
  const _Content({
    required this.place,
    required this.vm,
    required this.reviewsController,
  });

  final Place place;
  final PlaceDetailsViewModel vm;
  final LoopPageController reviewsController;

  @override
  Widget build(BuildContext context) {
    final photoUrl = place.photoRefs.isEmpty
        ? null
        : vm.photoUrl(place.photoRefs.first, maxWidthPx: 1200);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: _OuterCard(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place.displayName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              _HeroPhoto(url: photoUrl),
              const SizedBox(height: 14),
              _MetaSection(place: place),
              const SizedBox(height: 16),
              if (place.reviews.isNotEmpty) ...[
                _ReviewsFrame(
                  reviews: place.reviews,
                  controller: reviewsController,
                  currentIndex: vm.currentReviewIndex,
                  onPageChanged: vm.setCurrentReviewIndex,
                ),
                const SizedBox(height: 12),
                _DotsIndicator(
                  count: place.reviews.length,
                  activeIndex: vm.currentReviewIndex,
                ),
              ] else
                const _NoReviewsPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }
}

class _OuterCard extends StatelessWidget {
  const _OuterCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: url == null
            ? _PhotoFallback()
            : CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    const Pulse(child: SkeletonBox(radius: 0)),
                errorWidget: (_, _, _) => _PhotoFallback(),
              ),
      ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.separator,
      child: const Center(
        child: Icon(Icons.image_outlined, size: 36, color: AppColors.label),
      ),
    );
  }
}

class _MetaSection extends StatelessWidget {
  const _MetaSection({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: AppColors.separator),
        _MetaRow(
          icon: Icons.star_border_rounded,
          child: Text(
            place.rating == null
                ? 'No reviews yet'
                : place.rating!.toStringAsFixed(1),
            style: const _MetaTextStyle(),
          ),
        ),
        _MetaRow(
          icon: Icons.access_time_rounded,
          child: _OpeningHoursLine(place: place),
        ),
        _MetaRow(
          icon: Icons.attach_money_rounded,
          child: Text(
            _priceLabel(place.priceLevel),
            style: const _MetaTextStyle(),
          ),
        ),
        _MetaRow(
          icon: Icons.location_on_outlined,
          child: Text(
            place.formattedAddress ?? 'Address unknown',
            style: const _MetaTextStyle(),
          ),
        ),
      ],
    );
  }

  String _priceLabel(int? level) {
    if (level == null) return 'Price unknown';
    if (level == 0) return 'Free';
    final dollars = '\$' * level.clamp(1, 4);
    const labels = ['Inexpensive', 'Moderate', 'Expensive', 'Very expensive'];
    final label = labels[(level - 1).clamp(0, 3)];
    return '$dollars  $label';
  }
}

class _MetaTextStyle extends TextStyle {
  const _MetaTextStyle()
    : super(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.child});

  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textPrimary),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _OpeningHoursLine extends StatelessWidget {
  const _OpeningHoursLine({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final hours = place.openingHours;
    if (hours == null) {
      return const Text('Hours unknown', style: _MetaTextStyle());
    }
    final todayText = _todaysHours(hours.weekdayDescriptions);
    final openNow = hours.openNow;
    return Row(
      children: [
        Expanded(
          child: Text(
            todayText ?? 'Hours unknown',
            style: const _MetaTextStyle(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (openNow != null) ...[
          const SizedBox(width: 8),
          Text(
            openNow ? 'OPEN' : 'CLOSED',
            style: TextStyle(
              color: openNow ? const Color(0xFF2EA84A) : Colors.redAccent,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  /// `weekdayDescriptions` from Google starts with Monday at index 0.
  /// `DateTime.weekday` returns 1=Mon..7=Sun, so index = weekday - 1.
  /// Each entry looks like "Monday: 8:00 AM – 8:00 PM"; we strip the
  /// weekday name so only the time range is shown.
  String? _todaysHours(List<String> descriptions) {
    if (descriptions.isEmpty) return null;
    final idx = (DateTime.now().weekday - 1).clamp(0, descriptions.length - 1);
    final line = descriptions[idx];
    final colon = line.indexOf(':');
    if (colon < 0 || colon == line.length - 1) return line;
    return line.substring(colon + 1).trim();
  }
}

/// Bordered (no-shadow) frame holding the review carousel, so reviews don't
/// look like a second card stacked on top of the main card.
class _ReviewsFrame extends StatelessWidget {
  const _ReviewsFrame({
    required this.reviews,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  final List<PlaceReview> reviews;
  final LoopPageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.separator),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 210,
        child: LoopPageView.builder(
          controller: controller,
          itemCount: reviews.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            return _ReviewItem(review: reviews[index]);
          },
        ),
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({required this.review});

  final PlaceReview review;

  static const int _bodyMaxLines = 3;

  @override
  Widget build(BuildContext context) {
    final filled = review.rating.round().clamp(0, 5);
    final body = _reviewBody(review);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < 5; i++)
                Icon(
                  i < filled ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _reviewTitle(review),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Expanded(child: _ExpandableReviewBody(text: body, review: review)),
          const SizedBox(height: 4),
          Row(
            children: [
              _Avatar(url: review.authorAvatarUrl),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _dateLabel(review),
                      style: const TextStyle(
                        color: AppColors.label,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Google Places (New) reviews don't expose a separate title - the body is
  /// the only text. Show the first sentence (or first 60 chars) as a title and
  /// keep the rest as the body so the card matches the design's title+body
  /// layout without inventing data.
  String _reviewTitle(PlaceReview review) {
    final text = review.text.trim();
    if (text.isEmpty) return 'Review';
    final firstSentence = RegExp(r'^[^.!?]+[.!?]').firstMatch(text)?.group(0);
    final candidate = firstSentence ?? text;
    if (candidate.length <= 60) return candidate.trim();
    return '${candidate.substring(0, 60).trim()}…';
  }

  String _reviewBody(PlaceReview review) {
    final text = review.text.trim();
    if (text.isEmpty) return '';
    final firstSentence = RegExp(r'^[^.!?]+[.!?]').firstMatch(text)?.group(0);
    if (firstSentence == null || firstSentence.length >= text.length) {
      return text;
    }
    return text.substring(firstSentence.length).trim();
  }

  String _dateLabel(PlaceReview review) {
    if (review.relativeTime != null && review.relativeTime!.isNotEmpty) {
      return review.relativeTime!;
    }
    if (review.publishedAt != null) {
      return DateFormat('MMM d, yyyy').format(review.publishedAt!);
    }
    return '';
  }
}

/// Renders the review body limited to 3 lines. When the text would overflow,
/// shows an inline "Read more" link at the bottom that opens a modal sheet
/// with the full review. Uses `TextPainter` to detect overflow against the
/// available width so we don't show "Read more" when the text actually fits.
class _ExpandableReviewBody extends StatelessWidget {
  const _ExpandableReviewBody({required this.text, required this.review});

  final String text;
  final PlaceReview review;

  static const TextStyle _style = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 13,
    height: 1.3,
  );

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: _style),
          maxLines: _ReviewItem._bodyMaxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;
        if (!overflows) {
          return Text(text, style: _style);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: _style,
              maxLines: _ReviewItem._bodyMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showFullReview(context, review),
              child: const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  'Read more',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showFullReview(BuildContext context, PlaceReview review) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _FullReviewSheet(review: review),
    );
  }
}

class _FullReviewSheet extends StatelessWidget {
  const _FullReviewSheet({required this.review});

  final PlaceReview review;

  @override
  Widget build(BuildContext context) {
    final filled = review.rating.round().clamp(0, 5);
    final maxH = MediaQuery.of(context).size.height * 0.75;
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 14),
              Row(
                children: [
                  _Avatar(url: review.authorAvatarUrl),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.authorName,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          _dateLabel(review),
                          style: const TextStyle(
                            color: AppColors.label,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (var i = 0; i < 5; i++)
                    Icon(
                      i < filled
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    review.text,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dateLabel(PlaceReview r) {
    if (r.relativeTime != null && r.relativeTime!.isNotEmpty) {
      return r.relativeTime!;
    }
    if (r.publishedAt != null) {
      return DateFormat('MMM d, yyyy').format(r.publishedAt!);
    }
    return '';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 28,
        height: 28,
        child: url == null || url!.isEmpty
            ? Container(
                color: AppColors.separator,
                child: const Icon(
                  Icons.person_outline,
                  size: 18,
                  color: AppColors.label,
                ),
              )
            : CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(
                  color: AppColors.separator,
                  child: const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: AppColors.label,
                  ),
                ),
              ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final clamped = count.clamp(1, 8);
    final activeMod = count == 0 ? 0 : activeIndex % count;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < clamped; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == activeMod ? 8 : 6,
            height: i == activeMod ? 8 : 6,
            decoration: BoxDecoration(
              color: i == activeMod
                  ? AppColors.textPrimary
                  : AppColors.label.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

class _NoReviewsPlaceholder extends StatelessWidget {
  const _NoReviewsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.separator),
      ),
      child: const Center(
        child: Text(
          'No reviews yet',
          style: TextStyle(color: AppColors.label, fontSize: 13),
        ),
      ),
    );
  }
}

class _AddFab extends StatelessWidget {
  const _AddFab({required this.onTap, required this.running});

  final VoidCallback onTap;
  final bool running;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(24),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: running ? null : onTap,
        child: SizedBox(
          width: 96,
          height: 44,
          child: Center(
            child: running
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textSecondary,
                      ),
                    ),
                  )
                : const Text(
                    'Add',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _OuterCard(
        child: Pulse(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(height: 20, width: 220, radius: 6),
                SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: SkeletonBox(radius: 14),
                ),
                SizedBox(height: 18),
                SkeletonBox(height: 14, width: 100, radius: 4),
                SizedBox(height: 12),
                SkeletonBox(height: 14, width: 200, radius: 4),
                SizedBox(height: 12),
                SkeletonBox(height: 14, width: 140, radius: 4),
                SizedBox(height: 12),
                SkeletonBox(height: 14, width: 240, radius: 4),
                SizedBox(height: 18),
                SkeletonBox(height: 200, radius: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.label),
            const SizedBox(height: 12),
            const Text(
              "Couldn't load place details",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.textSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
