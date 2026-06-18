part of 'home_screen.dart';

/// Mobile presentation of Home: the hero form over a background image, then a
/// rounded sheet with the planned-trips list and a two-column suggested-
/// countries grid. Data and callbacks come from [HomeScreen].
class HomeMobileView extends StatelessWidget {
  const HomeMobileView({
    super.key,
    required this.viewModel,
    required this.destinationController,
    required this.budgetController,
    required this.onPickDates,
  });

  final HomeViewModel viewModel;
  final TextEditingController destinationController;
  final TextEditingController budgetController;
  final VoidCallback onPickDates;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          bottom: 350,
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: AppColors.authBg),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _HeroForm(
                  viewModel: viewModel,
                  destinationController: destinationController,
                  budgetController: budgetController,
                  onPickDates: onPickDates,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: _Sheet(viewModel: viewModel)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.sheetBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverMainAxisGroup(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: const _StickyHeaderDelegate(title: 'Planned trips'),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverToBoxAdapter(
                    child: _PlannedTripsList(viewModel: viewModel),
                  ),
                ),
              ],
            ),
            SliverMainAxisGroup(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: const _StickyHeaderDelegate(
                    title: 'Suggested countries to visit',
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    4,
                    16,
                    20 + MediaQuery.of(context).padding.bottom,
                  ),
                  sliver: _SuggestedCountriesSliverGrid(viewModel: viewModel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _StickyHeaderDelegate({required this.title});

  final String title;

  static const double _height = 48;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.label,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) =>
      oldDelegate.title != title;
}

class _SuggestedCountriesSliverGrid extends StatelessWidget {
  const _SuggestedCountriesSliverGrid({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final countries = viewModel.suggestedCountries;
    final isLoading =
        countries.isEmpty && viewModel.loadSuggestedCountries.running;
    final itemCount = countries.isEmpty ? 8 : countries.length;
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index >= countries.length) {
          return _SuggestedCountryCard(
            label: isLoading ? '' : 'Place ${index + 1}',
            photoUrl: null,
          );
        }
        final place = countries[index];
        return _SuggestedCountryCard(
          label: place.displayName,
          photoUrl: viewModel.suggestedCountryPhotoUrl(place),
        );
      }, childCount: itemCount),
    );
  }
}
