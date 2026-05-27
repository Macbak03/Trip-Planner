import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/config/app_theme.dart';
import 'package:trip_planner/domain/models/place/place_suggestion.dart';
import 'package:trip_planner/domain/models/trip/trip.dart';
import 'package:trip_planner/routing/routes.dart';
import 'package:trip_planner/ui/core/widgets/primary_button.dart';
import 'package:trip_planner/ui/home/view_models/home_viewmodel.dart';
import 'package:trip_planner/utils/result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _destinationController;
  late final TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _destinationController = TextEditingController(
      text: widget.viewModel.draft.destination,
    );
    _budgetController = TextEditingController(
      text: widget.viewModel.draft.budget?.toStringAsFixed(0) ?? '',
    );
    widget.viewModel.startPlanning.addListener(_onStartPlanningChanged);
  }

  @override
  void dispose() {
    widget.viewModel.startPlanning.removeListener(_onStartPlanningChanged);
    _destinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _onStartPlanningChanged() {
    final cmd = widget.viewModel.startPlanning;
    final result = cmd.result;
    if (!cmd.running && result is Ok<String>) {
      final id = result.value;
      widget.viewModel.clearCreatedTripId();
      _destinationController.clear();
      _budgetController.clear();
      cmd.clearResult();
      context.push(Routes.tripDetailsPath(id));
    }
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final draft = widget.viewModel.draft;
    final initial = (draft.startDate != null && draft.endDate != null)
        ? DateTimeRange(start: draft.startDate!, end: draft.endDate!)
        : null;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDateRange: initial,
    );
    if (picked != null) {
      widget.viewModel.setDateRange(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 350,
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: AppColors.authBg),
            ),
          ),
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: _HeroForm(
                        viewModel: viewModel,
                        destinationController: _destinationController,
                        budgetController: _budgetController,
                        onPickDates: () => _pickDateRange(context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(child: _Sheet(viewModel: viewModel)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroForm extends StatelessWidget {
  const _HeroForm({
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
    final draft = viewModel.draft;
    final dateLabel = (draft.startDate != null && draft.endDate != null)
        ? '${DateFormat('MMM d, yyyy').format(draft.startDate!)}   —   '
              '${DateFormat('MMM d, yyyy').format(draft.endDate!)}'
        : null;
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 5),
        _PillField(
          icon: Icons.place_outlined,
          hint: 'Destination',
          controller: destinationController,
          onChanged: viewModel.setDestination,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: viewModel.destinationSuggestions.isEmpty
              ? const SizedBox(width: double.infinity)
              : _DestinationSuggestionsOverlay(
                  suggestions: viewModel.destinationSuggestions,
                  onSelected: (s) {
                    viewModel.selectDestinationSuggestion(s);
                    destinationController.text = s.mainText;
                    destinationController.selection =
                        TextSelection.collapsed(offset: s.mainText.length);
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
        ),
        _PillField(
          icon: Icons.attach_money,
          hint: 'Budget',
          controller: budgetController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          onChanged: viewModel.setBudget,
          trailing: Text(
            draft.currency,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _PillField(
          icon: Icons.calendar_today_outlined,
          hint: 'Dates',
          readOnly: true,
          text: dateLabel,
          onTap: onPickDates,
        ),
        if (viewModel.formError != null) ...[
          const SizedBox(height: 8),
          Text(
            viewModel.formError!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
        ],
        const SizedBox(height: 16),
        ListenableBuilder(
          listenable: viewModel.startPlanning,
          builder: (context, _) => PrimaryButton(
            label: 'Start planning my trip',
            isLoading: viewModel.startPlanning.running,
            onPressed: viewModel.startPlanning.running
                ? null
                : () => viewModel.startPlanning.execute(),
          ),
        ),
      ],
    );
  }
}

class _DestinationSuggestionsOverlay extends StatelessWidget {
  const _DestinationSuggestionsOverlay({
    required this.suggestions,
    required this.onSelected,
  });

  static const double _overlayHeight = 175;

  final List<PlaceSuggestion> suggestions;
  final ValueChanged<PlaceSuggestion> onSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: _overlayHeight,
          decoration: BoxDecoration(
            color: AppColors.heroPillBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            itemCount: suggestions.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: AppColors.textSecondary.withValues(alpha: 0.15),
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, i) => _SuggestionRow(
              suggestion: suggestions[i],
              onTap: () => onSelected(suggestions[i]),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.suggestion, required this.onTap});

  final PlaceSuggestion suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            const Icon(
              Icons.place_outlined,
              color: AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.mainText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (suggestion.secondaryText.isNotEmpty)
                    Text(
                      suggestion.secondaryText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.75),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  const _PillField({
    required this.icon,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.trailing,
    this.text,
  });

  final IconData icon;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? trailing;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.heroPillBackground,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: readOnly && controller == null
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTap,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            text ?? hint,
                            style: TextStyle(
                              color: text == null
                                  ? AppColors.textSecondary
                                        .withValues(alpha: 0.8)
                                  : AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : TextField(
                        controller: controller,
                        onChanged: onChanged,
                        onTap: onTap,
                        readOnly: readOnly,
                        keyboardType: keyboardType,
                        inputFormatters: inputFormatters,
                        cursorColor: AppColors.textSecondary,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: hint,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary
                                .withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
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

class _PlannedTripsList extends StatelessWidget {
  const _PlannedTripsList({required this.viewModel});

  final HomeViewModel viewModel;

  Future<bool> _confirmDelete(BuildContext context, Trip trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usunąć wycieczkę?'),
        content: Text(
          'Czy na pewno chcesz usunąć wycieczkę do "${trip.destination}"? '
          'Tej operacji nie można cofnąć.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trip>>(
      stream: viewModel.plannedTrips,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Nie udało się wczytać wycieczek',
              style: TextStyle(color: Colors.red.shade400),
            ),
          );
        }
        final trips = snapshot.data ?? const <Trip>[];
        if (trips.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'Brak zaplanowanych wycieczek.\nZaplanuj swoją pierwszą podróż powyżej.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.label,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }
        return Column(
          children: [
            for (var i = 0; i < trips.length; i++) ...[
              Dismissible(
                key: ValueKey('trip-${trips[i].id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                confirmDismiss: (_) => _confirmDelete(context, trips[i]),
                onDismissed: (_) => viewModel.deleteTrip(trips[i].id),
                child: _TripRow(
                  trip: trips[i],
                  coverUrlFuture: viewModel.getTripCoverUrl(trips[i]),
                  onTap: () => context.push(Routes.tripDetailsPath(trips[i].id)),
                ),
              ),
              if (i != trips.length - 1)
                const Divider(height: 1, color: AppColors.separator),
            ],
          ],
        );
      },
    );
  }
}

class _TripRow extends StatelessWidget {
  const _TripRow({
    required this.trip,
    required this.coverUrlFuture,
    required this.onTap,
  });

  final Trip trip;
  final Future<String?> coverUrlFuture;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 52,
                height: 52,
                child: FutureBuilder<String?>(
                  future: coverUrlFuture,
                  builder: (context, snapshot) {
                    final url = snapshot.data;
                    if (url == null || url.isEmpty) {
                      return Container(
                        color: AppColors.separator,
                        child: const Icon(
                          Icons.image_outlined,
                          size: 22,
                          color: AppColors.label,
                        ),
                      );
                    }
                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          const ColoredBox(color: AppColors.separator),
                      errorWidget: (_, _, _) => Container(
                        color: AppColors.separator,
                        child: const Icon(
                          Icons.image_outlined,
                          size: 22,
                          color: AppColors.label,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                trip.destination,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              DateFormat('dd.MM.yyyy').format(trip.startDate),
              style: const TextStyle(
                color: AppColors.label,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.label, size: 20),
          ],
        ),
      ),
    );
  }
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

class _SuggestedCountryCard extends StatelessWidget {
  const _SuggestedCountryCard({required this.label, required this.photoUrl});

  final String label;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              color: AppColors.separator,
              child: (photoUrl == null || photoUrl!.isEmpty)
                  ? const SizedBox.expand()
                  : CachedNetworkImage(
                      imageUrl: photoUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (_, _) =>
                          const ColoredBox(color: AppColors.separator),
                      errorWidget: (_, _, _) =>
                          const ColoredBox(color: AppColors.separator),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
