part of 'home_screen.dart';

/// Web presentation of Home: a full-width hero banner with a centered form, then
/// a width-capped content column with a planned-trips card and a multi-column
/// suggested-countries grid. Data and callbacks come from [HomeScreen].
class HomeWebView extends StatelessWidget {
  const HomeWebView({
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
    return SingleChildScrollView(
      child: Column(
        children: [
          _WebHero(
            viewModel: viewModel,
            destinationController: destinationController,
            budgetController: budgetController,
            onPickDates: onPickDates,
          ),
          // Rounded sheet overlapping the hero (like the mobile layout).
          Transform.translate(
            offset: const Offset(0, -28),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.sheetBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: MaxWidthCenter(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 56),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: planned trips, narrowed to a fixed column so the
                    // suggested-countries grid keeps its four-across layout.
                    SizedBox(
                      width: 360,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _WebSectionTitle('Planned trips'),
                          const SizedBox(height: 14),
                          _WebCard(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 6,
                              ),
                              child: _PlannedTripsList(viewModel: viewModel),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Right: suggested countries as a four-column grid.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _WebSectionTitle(
                            'Suggested countries to visit',
                          ),
                          const SizedBox(height: 18),
                          _WebSuggestedCountriesGrid(viewModel: viewModel),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebHero extends StatelessWidget {
  const _WebHero({
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
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 320),
      decoration: const BoxDecoration(
        color: AppColors.authBg,
        image: DecorationImage(
          image: AssetImage('assets/images/background_web.png'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          onError: _ignoreImageError,
        ),
      ),
      // Extra bottom padding so the overlapping content sheet (translated up by
      // 28px) covers only the image, never the form's button.
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 88),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Plan your next trip',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                  ),
                ),
                const SizedBox(height: 22),
                _HeroForm(
                  viewModel: viewModel,
                  destinationController: destinationController,
                  budgetController: budgetController,
                  onPickDates: onPickDates,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `DecorationImage` needs an [ImageErrorListener]; a no-op keeps the hero's
/// solid fallback color visible if the asset can't be loaded.
void _ignoreImageError(Object error, StackTrace? stackTrace) {}

class _WebSectionTitle extends StatelessWidget {
  const _WebSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _WebCard extends StatelessWidget {
  const _WebCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _WebSuggestedCountriesGrid extends StatelessWidget {
  const _WebSuggestedCountriesGrid({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final countries = viewModel.suggestedCountries;
    final isLoading =
        countries.isEmpty && viewModel.loadSuggestedCountries.running;
    // Always four tiles across (the section sits in the right column of the
    // side-by-side content layout), so cap the placeholder count to one row.
    final itemCount = countries.isEmpty ? 4 : countries.length;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.4,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
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
      },
    );
  }
}
