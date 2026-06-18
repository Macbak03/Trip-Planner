import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/config/app_theme.dart';
import 'package:trip_planner/routing/routes.dart';
import 'package:trip_planner/ui/core/widgets/frosted_circle_button.dart';
import 'package:trip_planner/ui/settings/view_models/settings_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.logout.addListener(_onActionChanged);
    widget.viewModel.deleteAccount.addListener(_onActionChanged);
  }

  @override
  void dispose() {
    widget.viewModel.logout.removeListener(_onActionChanged);
    widget.viewModel.deleteAccount.removeListener(_onActionChanged);
    super.dispose();
  }

  /// Surfaces command failures as a snackbar. On success the [AuthNotifier]
  /// auth-state change drives the router redirect back to the auth screen, so
  /// no explicit navigation is needed here.
  void _onActionChanged() {
    final error = widget.viewModel.error;
    if (error == null) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade400,
        content: Text(error.description),
      ),
    );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'This permanently deletes your account. This action cannot be '
          'undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await widget.viewModel.deleteAccount.execute();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    return Scaffold(
      backgroundColor: AppColors.sheetBackground,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([vm.logout, vm.deleteAccount]),
          builder: (context, _) {
            final busy = vm.logout.running || vm.deleteAccount.running;
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FrostedCircleButton(
                        icon: Icons.arrow_back,
                        tooltip: 'Back',
                        onTap: _goBack,
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Settings',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _AccountCard(email: vm.userEmail),
                  const SizedBox(height: 16),
                  _ActionsCard(
                    busy: busy,
                    loggingOut: vm.logout.running,
                    deleting: vm.deleteAccount.running,
                    onLogout: () => vm.logout.execute(),
                    onDeleteAccount: _confirmDeleteAccount,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Logged in as',
              style: TextStyle(
                color: AppColors.labelSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email ?? 'Unknown account',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({
    required this.busy,
    required this.loggingOut,
    required this.deleting,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final bool busy;
  final bool loggingOut;
  final bool deleting;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          _ActionRow(
            icon: Icons.logout,
            label: 'Log out',
            color: AppColors.textPrimary,
            loading: loggingOut,
            onTap: busy ? null : onLogout,
          ),
          const Divider(height: 1, color: AppColors.separator, indent: 18),
          _ActionRow(
            icon: Icons.delete_outline,
            label: 'Delete account',
            color: Colors.red.shade400,
            loading: deleting,
            onTap: busy ? null : onDeleteAccount,
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.loading,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (loading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(
                Icons.chevron_right,
                color: AppColors.label,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

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
