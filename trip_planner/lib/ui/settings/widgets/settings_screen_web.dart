part of 'settings_screen.dart';

/// Web presentation of the Settings screen: the same back button, title and
/// account/actions cards, centered in a width-capped, scrollable column. All
/// data and actions are passed in by [SettingsScreen].
class SettingsWebView extends StatelessWidget {
  const SettingsWebView({
    super.key,
    required this.email,
    required this.busy,
    required this.loggingOut,
    required this.deleting,
    required this.onBack,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final String? email;
  final bool busy;
  final bool loggingOut;
  final bool deleting;
  final VoidCallback onBack;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MaxWidthCenter(
        maxWidth: 620,
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FrostedCircleButton(
                  icon: Icons.arrow_back,
                  tooltip: 'Back',
                  onTap: onBack,
                ),
                const SizedBox(width: 14),
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _AccountCard(email: email),
            const SizedBox(height: 16),
            _ActionsCard(
              busy: busy,
              loggingOut: loggingOut,
              deleting: deleting,
              onLogout: onLogout,
              onDeleteAccount: onDeleteAccount,
            ),
          ],
        ),
      ),
    );
  }
}
